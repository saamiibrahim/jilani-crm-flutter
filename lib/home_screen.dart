import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_state.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Register the observer to listen for lifecycle state changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Unregister the observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Overriding didChangeAppLifecycleState to implement the "Jaldi Loop"
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final appState = Provider.of<AppState>(context, listen: false);

    // When the app resumes and we are returning from a call, trigger the modal
    if (state == AppLifecycleState.resumed && appState.isReturningFromCall) {
      // Defer the dialog to ensure the context is valid and layout is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUpdateModal(context);
      });
    }
  }

  Future<void> _makeCall(Lead lead) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final Uri callUri = Uri.parse('tel:${lead.phoneNumber}');
    
    // Set state flags immediately before launching the intent
    appState.isReturningFromCall = true;
    appState.activeLeadId = lead.id;

    if (!await launchUrl(callUri)) {
      appState.isReturningFromCall = false; // Reset if launch fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch ${lead.phoneNumber}')),
        );
      }
    }
  }

  void _showUpdateModal(BuildContext screenContext) {
    final statusOptions = ['Interested', 'Not Interested', 'Call Back'];
    String selectedStatus = statusOptions.first;
    final notesController = TextEditingController();

    showDialog(
      context: screenContext,
      barrierDismissible: false, // Critical: User must interact with this modal
      builder: (BuildContext dialogContext) {
        // PopScope prevents Android back button from dismissing the modal
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: Theme.of(screenContext).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(color: Color(0xFFC5A059), width: 1.5), // Subtle gold border
            ),
            title: Text(
              'Call Outcome',
              style: Theme.of(screenContext).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFFC5A059),
                  ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      dropdownColor: Theme.of(screenContext).colorScheme.surface,
                      items: statusOptions
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC5A059)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Call Notes',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC5A059)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              Consumer<AppState>(
                builder: (context, appState, child) {
                  return appState.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: Color(0xFFC5A059)),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            final notes = notesController.text.trim();
                            await appState.updateLeadStatus(selectedStatus, notes);
                            
                            // On success, close the modal and reset states
                            if (appState.error == null && dialogContext.mounted) {
                              appState.isReturningFromCall = false;
                              Navigator.of(dialogContext).pop();
                            } else if (appState.error != null && dialogContext.mounted) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(content: Text(appState.error!)),
                              );
                            }
                          },
                          child: const Text('SUBMIT'),
                        );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Circular gold icon representation, using an icon as fallback if image unvailable
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC5A059), width: 1.5),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/image_0.png', // Assuming user places a variant or scales it
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.apartment,
                    color: Color(0xFFC5A059),
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text('LEADS FEED', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFC5A059)),
            onPressed: () => context.read<AppState>().fetchLeads(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            onPressed: () => context.read<AppState>().logout(),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading && appState.leads.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFC5A059)));
          }

          if (appState.error != null && appState.leads.isEmpty) {
            return Center(
              child: Text(
                'Error: ${appState.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          if (appState.leads.isEmpty) {
            return Center(
              child: Text(
                'No new leads available.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFFC5A059),
            onRefresh: () => appState.fetchLeads(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: appState.leads.length,
              itemBuilder: (context, index) {
                final lead = appState.leads[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                      color: const Color(0xFFC5A059).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 22,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          lead.company,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Divider(
                          color: Color(0xFFC5A059), // Gold separator
                          thickness: 0.5,
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lead.phoneNumber,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            // Metallic gold gradient button feeling
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFD4AF37), Color(0xFFAA8028)], // Gold gradient approximation
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                icon: const Icon(Icons.phone, color: Colors.white, size: 20),
                                label: const Text('CALL', style: TextStyle(letterSpacing: 1.2)),
                                onPressed: () => _makeCall(lead),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
