import 'package:flutter/material.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';
import '../widgets/crm_components.dart';
import 'lead_detail_screen.dart';
import 'lead_filter_screen.dart';
import 'settings_screen.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  bool _searching = false;
  String _query = '';
  FilterState _filter = const FilterState();

  List<CrmLead> get _visibleLeads {
    final query = _query.toLowerCase().trim();
    return DummyData.leads.where((lead) {
      final matchesSearch =
          query.isEmpty ||
          lead.name.toLowerCase().contains(query) ||
          lead.phone.toLowerCase().contains(query);
      final matchesStatus =
          _filter.statuses.isEmpty || _filter.statuses.contains(lead.status);
      final matchesCampaign =
          _filter.campaigns.isEmpty ||
          _filter.campaigns.contains(lead.campaign);
      final matchesSource =
          _filter.sources.isEmpty || _filter.sources.contains(lead.source);
      return matchesSearch && matchesStatus && matchesCampaign && matchesSource;
    }).toList();
  }

  Future<void> _openFilter() async {
    final selected = await Navigator.of(context).push<FilterState>(
      DesignSystem.route(
        LeadFilterScreen(initialFilter: _filter),
        fullscreenDialog: true,
      ),
    );
    if (selected != null) setState(() => _filter = selected);
  }

  Future<void> _showAddLead() async {
    await Navigator.of(context).push<void>(
      DesignSystem.route(const _AddLeadScreen()),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final leads = _visibleLeads;
    return Scaffold(
      appBar: JilaniAppBar(
        showLogoTitle: !_searching,
        title: _searching ? '' : null,
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _searching = !_searching;
              if (!_searching) _query = '';
            }),
          ),
          ProfileButton(
            onTap: () => Navigator.of(context).push(
              DesignSystem.route<void>(const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: ScreenBackdrop(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_searching)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Insets.s20,
                  Insets.s16,
                  Insets.s20,
                  Insets.s8,
                ),
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search leads',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.s20,
                Insets.s16,
                Insets.s20,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _ToolbarButton(
                      icon: Icons.filter_list,
                      label: _filter.isEmpty
                          ? 'Filter'
                          : 'Filter (${_filter.selectedCount})',
                      onTap: _openFilter,
                    ),
                  ),
                  const SizedBox(width: Insets.s12),
                  Expanded(
                    child: _ToolbarButton(
                      icon: Icons.sort,
                      label: 'Newest first',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.s20,
                Insets.s20,
                Insets.s20,
                Insets.s12,
              ),
              child: Text(
                'Total leads: ${leads.length}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: p.onSurfaceVariant),
              ),
            ),
            Expanded(
              child: leads.isEmpty
                  ? const _EmptyLeads()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        Insets.s20,
                        0,
                        Insets.s20,
                        96,
                      ),
                      itemCount: leads.length,
                      itemBuilder: (context, index) {
                        final lead = leads[index];
                        return _LeadListCard(
                          lead: lead,
                          onTap: () {
                            Navigator.of(context).push(
                              DesignSystem.route<void>(
                                LeadDetailScreen(lead: lead),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('add-lead-fab'),
        onPressed: _showAddLead,
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _EmptyLeads extends StatelessWidget {
  const _EmptyLeads();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_outlined, size: 44, color: p.onSurfaceVariant),
            const SizedBox(height: Insets.s16),
            Text(
              'No leads match',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Insets.s8),
            Text(
              'Try clearing a filter or adding a new lead.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: p.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadListCard extends StatelessWidget {
  final CrmLead lead;
  final VoidCallback onTap;

  const _LeadListCard({required this.lead, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final accent = statusColor(lead.status);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.md),
      child: Container(
        margin: const EdgeInsets.only(bottom: Insets.s12),
        decoration: BoxDecoration(
          color: p.surfaceContainer,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: p.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LeadAvatar(radius: 19, name: lead.name),
                          const SizedBox(width: Insets.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  lead.campaign,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: p.onSurfaceVariant),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: Insets.s12),
                          StatusChip(
                            label: lead.status,
                            color: accent,
                          ),
                        ],
                      ),
                      const SizedBox(height: Insets.s12),
                      Row(
                        children: [
                          if (lead.dealValue.trim().isNotEmpty) ...[
                            Text(
                              '\$${lead.dealValue}',
                              style: DesignSystem.serif(
                                color: p.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                          ] else
                            const Spacer(),
                          Text(
                            formatCrmDate(lead.lastUpdated),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: p.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddLeadScreen extends StatefulWidget {
  const _AddLeadScreen();

  @override
  State<_AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<_AddLeadScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _notes = TextEditingController();
  String _owner = DummyData.owners.first;
  String _status = DummyData.leadStatuses.first;

  bool get _canAdd =>
      _firstName.text.trim().isNotEmpty && _phone.text.trim().isNotEmpty;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _email.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickOwner() async {
    final selected = await showOptionSheet(
      context: context,
      title: 'Owner',
      options: DummyData.owners,
      selected: _owner,
    );
    if (selected != null) setState(() => _owner = selected);
  }

  Future<void> _pickStatus() async {
    final selected = await showOptionSheet(
      context: context,
      title: 'Lead status',
      options: DummyData.leadStatuses,
      selected: _status,
    );
    if (selected != null) setState(() => _status = selected);
  }

  void _addLead() {
    if (!_canAdd) return;
    DummyData.leads.add(
      CrmLead(
        id: 'lead-${DateTime.now().millisecondsSinceEpoch}',
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        owner: _owner,
        campaign: 'Manual Leads',
        status: _status,
        source: 'CSV/Manual',
        notes: _notes.text.trim(),
        creationDate: DateTime.now(),
        lastUpdated: DateTime.now(),
        lastAssigned: DateTime.now(),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      appBar: const JilaniAppBar(title: 'Add lead', showBack: true),
      body: ScreenBackdrop(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Insets.s20,
            Insets.s20,
            Insets.s20,
            Insets.s24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FieldLabel(label: 'First name', isRequired: true),
              TextField(
                controller: _firstName,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(hintText: 'John'),
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Last name'),
              TextField(
                controller: _lastName,
                decoration: const InputDecoration(hintText: 'Doe'),
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Phone', isRequired: true),
              TextField(
                controller: _phone,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(hintText: '+97140000000'),
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Email'),
              TextField(
                controller: _email,
                decoration: const InputDecoration(hintText: 'john@email.com'),
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Owner', isRequired: true),
              PickerField(
                value: _owner,
                hint: 'Select owner',
                onTap: _pickOwner,
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Lead status', isRequired: true),
              PickerField(
                value: _status,
                hint: 'Select status',
                dotColor: statusColor(_status),
                onTap: _pickStatus,
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Notes'),
              TextField(
                controller: _notes,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Add some notes here',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: p.surface,
          border: Border(top: BorderSide(color: p.divider)),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(
            Insets.s20,
            Insets.s12,
            Insets.s20,
            Insets.s20,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: Insets.s12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _canAdd ? _addLead : null,
                  child: const Text('Add lead'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
