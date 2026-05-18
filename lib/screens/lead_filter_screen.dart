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
    final selected = await DesignSystem.luxeSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          _MultiSelectSheet(title: title, options: options, selected: current),
    );
    if (selected != null) setState(() => onChanged(selected));
  }

  void _apply() => Navigator.of(context).pop(_filter);

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final campaigns =
        DummyData.campaigns.map((campaign) => campaign.title).toSet().toList();
    final sources = DummyData.leads.map((lead) => lead.source).toSet().toList();

    return Scaffold(
      body: SafeArea(
        child: ScreenBackdrop(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              Insets.s20,
              Insets.s24,
              Insets.s20,
              96,
            ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'I want to see',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _clear,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Clear all'),
                  ),
                  const SizedBox(width: Insets.s8),
                  CompactIconButton(
                    tooltip: 'Close',
                    icon: Icons.close,
                    filled: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: Insets.s24),
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
              const SizedBox(height: Insets.s20),
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
          child: SizedBox(
            height: 54,
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
    final p = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.md),
      child: Container(
        margin: const EdgeInsets.only(bottom: Insets.s12),
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.s16,
          vertical: Insets.s16,
        ),
        decoration: BoxDecoration(
          color: p.surfaceContainer,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: p.outlineVariant),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (count > 0)
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: DesignSystem.sans(
                    color: p.onPrimaryContainer,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(width: Insets.s12),
            Icon(Icons.chevron_right, color: p.primaryContainer),
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
    final p = context.palette;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Insets.s20,
          Insets.s16,
          Insets.s20,
          Insets.s20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: Insets.s12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.options.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: p.divider),
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final selected = _selected.contains(option);
                  return CheckboxListTile(
                    value: selected,
                    title: Text(option),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
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
            const SizedBox(height: Insets.s12),
            SizedBox(
              width: double.infinity,
              height: 54,
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
