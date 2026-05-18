import 'package:flutter/material.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';
import '../widgets/crm_components.dart';

class LeadFilterScreen extends StatefulWidget {
  final FilterState initialFilter;

  const LeadFilterScreen({super.key, required this.initialFilter});

  @override
  State<LeadFilterScreen> createState() => _LeadFilterScreenState();
}

class _LeadFilterScreenState extends State<LeadFilterScreen> {
  late FilterState _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  void _clear() => setState(() => _filter = const FilterState());

  Future<void> _pickSet({
    required String title,
    required List<String> options,
    required Set<String> current,
    required ValueChanged<Set<String>> onChanged,
  }) async {
    final selected = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: DesignSystem.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) =>
          _MultiSelectSheet(title: title, options: options, selected: current),
    );
    if (selected != null) setState(() => onChanged(selected));
  }

  void _apply() => Navigator.of(context).pop(_filter);

  @override
  Widget build(BuildContext context) {
    final campaigns = DummyData.campaigns
        .map((campaign) => campaign.title)
        .toSet()
        .toList();
    final sources = DummyData.leads.map((lead) => lead.source).toSet().toList();

    return Scaffold(
      body: SafeArea(
        child: ScreenBackdrop(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 96),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'I want to see',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _clear,
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Clear all'),
                  ),
                  const SizedBox(width: 8),
                  CompactIconButton(
                    tooltip: 'Close',
                    icon: Icons.close,
                    filled: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _FilterRow(
                label: 'Status',
                count: _filter.statuses.length,
                onTap: () => _pickSet(
                  title: 'Status',
                  options: DummyData.leadStatuses,
                  current: _filter.statuses,
                  onChanged: (value) =>
                      _filter = _filter.copyWith(statuses: value),
                ),
              ),
              _FilterRow(
                label: 'Lead Source',
                count: _filter.sources.length,
                onTap: () => _pickSet(
                  title: 'Lead Source',
                  options: sources,
                  current: _filter.sources,
                  onChanged: (value) =>
                      _filter = _filter.copyWith(sources: value),
                ),
              ),
              _FilterRow(
                label: 'Campaign',
                count: _filter.campaigns.length,
                onTap: () => _pickSet(
                  title: 'Campaign',
                  options: campaigns,
                  current: _filter.campaigns,
                  onChanged: (value) =>
                      _filter = _filter.copyWith(campaigns: value),
                ),
              ),
              const SizedBox(height: 22),
              _FilterRow(
                label: 'Last Updated',
                count: _filter.dateFilters.length,
                onTap: () => _pickSet(
                  title: 'Last Updated',
                  options: const ['Today', 'This week', 'This month'],
                  current: _filter.dateFilters,
                  onChanged: (value) =>
                      _filter = _filter.copyWith(dateFilters: value),
                ),
              ),
              _FilterRow(label: 'Last Assigned', count: 0, onTap: () {}),
              _FilterRow(label: 'Creation Date', count: 0, onTap: () {}),
              _FilterRow(
                label: 'Deal Value',
                count: _filter.dealValues.length,
                onTap: () => _pickSet(
                  title: 'Deal Value',
                  options: const ['Has value', 'No value'],
                  current: _filter.dealValues,
                  onChanged: (value) =>
                      _filter = _filter.copyWith(dealValues: value),
                ),
              ),
              _FilterRow(
                label: 'Task Status',
                count: _filter.taskStatuses.length,
                onTap: () => _pickSet(
                  title: 'Task Status',
                  options: const ['Pending', 'Overdue', 'Completed'],
                  current: _filter.taskStatuses,
                  onChanged: (value) =>
                      _filter = _filter.copyWith(taskStatuses: value),
                ),
              ),
              _FilterRow(
                label: 'Task Type',
                count: _filter.taskTypes.length,
                onTap: () => _pickSet(
                  title: 'Task Type',
                  options: DummyData.taskTypes,
                  current: _filter.taskTypes,
                  onChanged: (value) =>
                      _filter = _filter.copyWith(taskTypes: value),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 10, 18, 20),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            key: const ValueKey('apply-filter-button'),
            onPressed: _apply,
            child: Text(
              _filter.isEmpty ? 'Apply' : 'Apply (${_filter.selectedCount})',
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onTap;

  const _FilterRow({
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: DesignSystem.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (count > 0)
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: DesignSystem.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: DesignSystem.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(width: 12),
            const Icon(
              Icons.chevron_right,
              color: DesignSystem.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}

class _MultiSelectSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final Set<String> selected;

  const _MultiSelectSheet({
    required this.title,
    required this.options,
    required this.selected,
  });

  @override
  State<_MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<_MultiSelectSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.options.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final selected = _selected.contains(option);
                  return CheckboxListTile(
                    value: selected,
                    title: Text(option),
                    onChanged: (value) {
                      setState(() {
                        if (value ?? false) {
                          _selected.add(option);
                        } else {
                          _selected.remove(option);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(_selected),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
