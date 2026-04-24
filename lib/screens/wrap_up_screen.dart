import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class WrapUpScreen extends StatefulWidget {
  const WrapUpScreen({super.key});

  @override
  State<WrapUpScreen> createState() => _WrapUpScreenState();
}

class _WrapUpScreenState extends State<WrapUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedStatus;
  String? _selectedOutcome;
  bool _addTask = false;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _statuses = ['Interested', 'Not Interested', 'Call Back', 'Qualified', 'Working Deal'];
  final List<String> _outcomes = ['Answered', 'No Answer', 'Busy', 'Wrong Number'];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wrap Up Call'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lead Status Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Lead Status'),
                      dropdownColor: DesignSystem.surfaceContainer,
                      value: _selectedStatus,
                      items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedStatus = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Call Outcome Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Call Outcome'),
                      dropdownColor: DesignSystem.surfaceContainer,
                      value: _selectedOutcome,
                      items: _outcomes.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedOutcome = val;
                        });
                      },
                    ),
                    const SizedBox(height: 32),

                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickAction(Icons.email, 'Email', Colors.blue),
                        _buildQuickAction(Icons.sms, 'SMS', Colors.green),
                        _buildQuickAction(Icons.message, 'WhatsApp', const Color(0xFF25D366)),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Add Task Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: DesignSystem.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SwitchListTile(
                        title: const Text('+ Add Task'),
                        value: _addTask,
                        onChanged: (val) {
                          setState(() {
                            _addTask = val;
                          });
                        },
                        activeColor: DesignSystem.primaryContainer,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        alignLabelWithHint: true,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.mic, color: DesignSystem.primaryContainer),
                          onPressed: () {
                            // Start voice dictation
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Sticky Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: DesignSystem.surfaceContainerLow,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save and next logic
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save & Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
