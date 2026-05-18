import 'package:flutter/material.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';
import '../widgets/crm_components.dart';

class WrapUpScreen extends StatefulWidget {
  final Campaign campaign;
  final CampaignLead lead;
  final int currentIndex;
  final int totalLeads;

  const WrapUpScreen({
    super.key,
    required this.campaign,
    required this.lead,
    required this.currentIndex,
    required this.totalLeads,
  });

  @override
  State<WrapUpScreen> createState() => _WrapUpScreenState();
}

class _WrapUpScreenState extends State<WrapUpScreen> {
  final TextEditingController _dealValueController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedOutcome;
  String? _selectedStatus;
  CrmTask? _task;

  bool get _canSave => _selectedOutcome != null && _selectedStatus != null;

  @override
  void dispose() {
    _dealValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickOutcome() async {
    final selected = await showOptionSheet(
      context: context,
      title: 'Call outcome',
      options: DummyData.callOutcomes,
      selected: _selectedOutcome,
    );
    if (selected != null) setState(() => _selectedOutcome = selected);
  }

  Future<void> _pickStatus() async {
    final selected = await showOptionSheet(
      context: context,
      title: 'Lead status',
      options: DummyData.leadStatuses,
      selected: _selectedStatus,
    );
    if (selected != null) setState(() => _selectedStatus = selected);
  }

  Future<void> _showCreateTaskSheet() async {
    final task = await DesignSystem.luxeSheet<CrmTask>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _TaskEditorSheet(lead: widget.lead),
    );

    if (task != null) setState(() => _task = task);
  }

  Future<void> _showNoteLog(String title) {
    return DesignSystem.luxeSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _LogActivitySheet(title: title),
    );
  }

  void _saveAndCallNext() {
    if (!_canSave) return;

    Navigator.of(context).pop(
      WrapUpResult(
        leadId: widget.lead.id,
        callOutcome: _selectedOutcome!,
        leadStatus: _selectedStatus!,
        dealValue: _dealValueController.text.trim(),
        notes: _notesController.text.trim(),
        task: _task,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      appBar: const JilaniAppBar(title: 'Wrap up', showBack: true),
      body: ScreenBackdrop(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Insets.s20,
            Insets.s16,
            Insets.s20,
            Insets.s24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HorizontalActions(
                lead: widget.lead,
                onMeeting: () => _showNoteLog('Log meeting'),
                onComment: () => _showNoteLog('Log comment'),
                onMore: () => _showNoteLog('Log activity'),
              ),
              const SizedBox(height: Insets.s20),
              LeadSummaryBlock(
                lead: widget.lead,
                onAddLabel: () => _showNoteLog('Add label'),
                onEdit: () => _showNoteLog('Edit lead'),
              ),
              const SizedBox(height: Insets.s16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showNoteLog('Add to phonebook'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add to phonebook'),
                ),
              ),
              const SizedBox(height: Insets.s24),
              const FieldLabel(label: 'Owner', isRequired: true),
              PickerField(
                value: widget.lead.owner,
                hint: 'Select owner',
                onTap: () {},
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Call outcome', isRequired: true),
              PickerField(
                key: const ValueKey('call-outcome-field'),
                value: _selectedOutcome,
                hint: 'Select call outcome',
                dotColor: _selectedOutcome == null
                    ? null
                    : statusColor(_selectedOutcome!),
                onTap: _pickOutcome,
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Lead status', isRequired: true),
              PickerField(
                key: const ValueKey('lead-status-field'),
                value: _selectedStatus,
                hint: 'Select lead status',
                dotColor: _selectedStatus == null
                    ? null
                    : statusColor(_selectedStatus!),
                onTap: _pickStatus,
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Deal value'),
              TextField(
                controller: _dealValueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(suffixText: 'USD'),
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Notes'),
              TextField(
                controller: _notesController,
                maxLines: 3,
                style: DesignSystem.serif(
                  color: p.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
                decoration: const InputDecoration(
                  hintText: 'Add some notes here',
                ),
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Task'),
              if (_task == null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    key: const ValueKey('add-task-button'),
                    onPressed: _showCreateTaskSheet,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add task'),
                  ),
                )
              else
                _TaskPreview(task: _task!, onEdit: _showCreateTaskSheet),
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
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              key: const ValueKey('save-and-call-next-button'),
              onPressed: _canSave ? _saveAndCallNext : null,
              icon: const Icon(Icons.arrow_forward, size: 20),
              label: Text(
                widget.currentIndex >= widget.totalLeads - 1
                    ? 'Save and finish'
                    : 'Save and call next',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskEditorSheet extends StatefulWidget {
  final CampaignLead lead;

  const _TaskEditorSheet({required this.lead});

  @override
  State<_TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<_TaskEditorSheet> {
  final TextEditingController _notesController = TextEditingController();
  String? _taskType;
  DateTime _date = DateTime(2026, 5, 6);
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 0);

  bool get _canAdd => _taskType != null;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickTaskType() async {
    final selected = await showOptionSheet(
      context: context,
      title: 'Task type',
      options: DummyData.taskTypes,
      selected: _taskType,
    );
    if (selected != null) setState(() => _taskType = selected);
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (selected != null) setState(() => _date = selected);
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(context: context, initialTime: _time);
    if (selected != null) setState(() => _time = selected);
  }

  void _addTask() {
    if (!_canAdd) return;
    Navigator.of(context).pop(
      CrmTask(
        id: 'task-${DateTime.now().millisecondsSinceEpoch}',
        leadId: widget.lead.id,
        leadName: widget.lead.name,
        taskType: _taskType!,
        status: 'Pending',
        dueDate: _date,
        dueTime: _time,
        notes: _notesController.text.trim(),
        statusColor: statusColor('Working deal'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Insets.s20,
          Insets.s16,
          Insets.s20,
          bottomInset + Insets.s20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Create task',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  CompactIconButton(
                    tooltip: 'Close',
                    icon: Icons.close,
                    filled: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: Insets.s24),
              const FieldLabel(label: 'Task type', isRequired: true),
              PickerField(
                key: const ValueKey('task-type-field'),
                value: _taskType,
                hint: 'Select task type',
                onTap: _pickTaskType,
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Notes'),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Add some notes here',
                ),
              ),
              const SizedBox(height: Insets.s16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(formatCrmDate(_date)),
                    ),
                  ),
                  const SizedBox(width: Insets.s12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickTime,
                      icon: const Icon(Icons.schedule, size: 18),
                      label: Text(_time.format(context)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.s20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  key: const ValueKey('create-task-submit'),
                  onPressed: _canAdd ? _addTask : null,
                  child: const Text('Add task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskPreview extends StatelessWidget {
  final CrmTask task;
  final VoidCallback onEdit;

  const _TaskPreview({required this.task, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: p.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: p.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Insets.s16),
            child: Row(
              children: [
                Icon(Icons.task_alt, color: p.primaryContainer),
                const SizedBox(width: Insets.s12),
                Expanded(
                  child: Text(
                    task.taskType,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                StatusChip(label: task.status, color: statusColor(task.status)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.s16, 0, Insets.s16, 14),
            child: Text(
              formatCrmDateTime(task.dueDate, task.dueTime),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: p.onSurfaceVariant),
            ),
          ),
          Divider(height: 1, color: p.divider),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit task'),
                ),
              ),
              Container(width: 1, height: 44, color: p.divider),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: p.primaryContainer,
                  ),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Complete task'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogActivitySheet extends StatelessWidget {
  final String title;

  const _LogActivitySheet({required this.title});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Insets.s20,
          Insets.s16,
          Insets.s20,
          bottomInset + Insets.s20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                CompactIconButton(
                  tooltip: 'Close',
                  icon: Icons.close,
                  filled: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: Insets.s20),
            const FieldLabel(label: 'Notes'),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(hintText: 'Add some notes here'),
            ),
            const SizedBox(height: Insets.s20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Log activity'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
