import 'package:flutter/material.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';
import '../widgets/crm_components.dart';

class LeadDetailScreen extends StatefulWidget {
  final CrmLead lead;

  const LeadDetailScreen({super.key, required this.lead});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  late final TextEditingController _dealValueController;

  CampaignLead get _campaignLead => widget.lead.toCampaignLead();

  List<CrmTask> get _tasks {
    return DummyData.tasks
        .where((task) => task.leadId == widget.lead.id && !task.isCompleted)
        .toList();
  }

  List<Activity> get _activities {
    return DummyData.activities
        .where((activity) => activity.leadId == widget.lead.id)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _dealValueController = TextEditingController(text: widget.lead.dealValue);
  }

  @override
  void dispose() {
    _dealValueController.dispose();
    super.dispose();
  }

  Future<void> _pickStatus() async {
    final selected = await showOptionSheet(
      context: context,
      title: 'Lead status',
      options: DummyData.leadStatuses,
      selected: widget.lead.status,
    );
    if (selected == null) return;
    setState(() {
      widget.lead.status = selected;
      widget.lead.lastUpdated = DateTime.now();
    });
  }

  Future<void> _pickOwner() async {
    final selected = await showOptionSheet(
      context: context,
      title: 'Owner',
      options: DummyData.owners,
      selected: widget.lead.owner,
    );
    if (selected == null) return;
    setState(() {
      widget.lead.owner = selected;
      widget.lead.lastAssigned = DateTime.now();
    });
  }

  Future<void> _showEditLead() {
    return DesignSystem.luxeSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EditLeadSheet(lead: widget.lead),
    ).then((_) => setState(() {}));
  }

  Future<void> _showLog(String title) {
    return DesignSystem.luxeSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _SimpleLogSheet(title: title),
    );
  }

  Future<void> _showCreateTaskSheet() async {
    final task = await DesignSystem.luxeSheet<CrmTask>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _LeadTaskEditorSheet(lead: widget.lead),
    );

    if (task == null) return;
    setState(() {
      DummyData.tasks.add(task);
      widget.lead.lastUpdated = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      appBar: const JilaniAppBar(title: 'Lead details', showBack: true),
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
              _LeadStatusStrip(lead: widget.lead),
              const SizedBox(height: Insets.s20),
              HorizontalActions(
                lead: _campaignLead,
                onMeeting: () => _showLog('Log meeting'),
                onComment: () => _showLog('Log comment'),
                onMore: () => _showLog('Log activity'),
              ),
              const SizedBox(height: Insets.s20),
              LeadSummaryBlock(
                lead: _campaignLead,
                showOwner: true,
                onAddLabel: () => _showLog('Add label'),
                onEdit: _showEditLead,
              ),
              const SizedBox(height: Insets.s16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showLog('Add to phonebook'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add to phonebook'),
                ),
              ),
              const SizedBox(height: Insets.s24),
              const FieldLabel(label: 'Owner', isRequired: true),
              PickerField(
                value: widget.lead.owner,
                hint: 'Owner',
                onTap: _pickOwner,
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Lead status', isRequired: true),
              PickerField(
                value: widget.lead.status,
                hint: 'Lead status',
                dotColor: statusColor(widget.lead.status),
                onTap: _pickStatus,
              ),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Deal value'),
              TextField(
                controller: _dealValueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(suffixText: 'USD'),
                onChanged: (value) => widget.lead.dealValue = value,
              ),
              const SizedBox(height: Insets.s24),
              _SectionHeader(title: 'Task'),
              const SizedBox(height: Insets.s12),
              if (_tasks.isEmpty)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    key: const ValueKey('add-lead-detail-task-button'),
                    onPressed: _showCreateTaskSheet,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add task'),
                  ),
                )
              else
                ..._tasks.map(
                  (task) =>
                      _TaskCard(task: task, onChanged: () => setState(() {})),
                ),
              const SizedBox(height: Insets.s24),
              _SectionHeader(title: 'Activities'),
              const SizedBox(height: Insets.s16),
              Text(
                'TODAY',
                style: DesignSystem.sans(
                  color: p.primaryContainer,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: Insets.s12),
              ..._activities.map(
                (activity) => _ActivityCard(activity: activity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _LeadStatusStrip extends StatelessWidget {
  final CrmLead lead;
  const _LeadStatusStrip({required this.lead});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final hasDeal = lead.dealValue.trim().isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: p.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: p.outlineVariant),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STATUS',
                style: DesignSystem.sans(
                  color: p.primaryContainer,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: Insets.s8),
              StatusChip(
                label: lead.status,
                color: statusColor(lead.status),
              ),
            ],
          ),
          const Spacer(),
          if (hasDeal)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'DEAL VALUE',
                  style: DesignSystem.sans(
                    color: p.primaryContainer,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: Insets.s8),
                Text(
                  '\$${lead.dealValue}',
                  style: DesignSystem.serif(
                    color: p.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final CrmTask task;
  final VoidCallback onChanged;

  const _TaskCard({required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: Insets.s12),
      decoration: BoxDecoration(
        color: p.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: p.outlineVariant),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Insets.s16),
            child: Row(
              children: [
                Icon(Icons.task_alt, color: p.primaryContainer),
                const SizedBox(width: Insets.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.taskType,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formatCrmDateTime(task.dueDate, task.dueTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: p.onSurfaceVariant,
                            ),
                      ),
                      if (task.notes.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          task.notes,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
                StatusChip(label: task.status, color: statusColor(task.status)),
              ],
            ),
          ),
          Divider(height: 1, color: p.divider),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 17),
                    label: const Text('Edit task'),
                  ),
                ),
                Container(width: 1, color: p.divider),
                Expanded(
                  child: TextButton.icon(
                    key: const ValueKey('complete-lead-task-button'),
                    style: TextButton.styleFrom(
                      foregroundColor: p.primaryContainer,
                    ),
                    onPressed: () {
                      task.isCompleted = true;
                      onChanged();
                    },
                    icon: const Icon(Icons.check, size: 17),
                    label: const Text('Complete task'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeadTaskEditorSheet extends StatefulWidget {
  final CrmLead lead;

  const _LeadTaskEditorSheet({required this.lead});

  @override
  State<_LeadTaskEditorSheet> createState() => _LeadTaskEditorSheetState();
}

class _LeadTaskEditorSheetState extends State<_LeadTaskEditorSheet> {
  final TextEditingController _notesController = TextEditingController();
  String? _taskType;
  DateTime _date = DateTime.now();
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
                key: const ValueKey('lead-detail-task-type-field'),
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
                  key: const ValueKey('create-lead-detail-task-submit'),
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

class _ActivityCard extends StatelessWidget {
  final Activity activity;

  const _ActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: Insets.s12),
      padding: const EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: p.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: p.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: activity.color.withValues(alpha: 0.16),
            ),
            alignment: Alignment.center,
            child: Icon(activity.icon, color: activity.color, size: 17),
          ),
          const SizedBox(width: Insets.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (activity.outcome != null) ...[
                  const SizedBox(height: Insets.s8),
                  _MiniLabel(text: 'Outcome'),
                  Text(activity.outcome!),
                ],
                if (activity.notes.isNotEmpty) ...[
                  const SizedBox(height: Insets.s8),
                  _MiniLabel(text: 'Notes'),
                  Text(activity.notes),
                ],
                const SizedBox(height: Insets.s12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'by ${activity.actor}',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: p.onSurfaceVariant),
                      ),
                    ),
                    Text(
                      TimeOfDay.fromDateTime(activity.timestamp)
                          .format(context),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: p.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniLabel extends StatelessWidget {
  final String text;
  const _MiniLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        text.toUpperCase(),
        style: DesignSystem.sans(
          color: p.onSurfaceVariant,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _EditLeadSheet extends StatefulWidget {
  final CrmLead lead;

  const _EditLeadSheet({required this.lead});

  @override
  State<_EditLeadSheet> createState() => _EditLeadSheetState();
}

class _EditLeadSheetState extends State<_EditLeadSheet> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: widget.lead.firstName);
    _lastName = TextEditingController(text: widget.lead.lastName);
    _phone = TextEditingController(text: widget.lead.phone);
    _email = TextEditingController(text: widget.lead.email ?? '');
    _notes = TextEditingController(text: widget.lead.notes ?? '');
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _email.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    widget.lead
      ..firstName = _firstName.text.trim()
      ..lastName = _lastName.text.trim()
      ..phone = _phone.text.trim()
      ..email = _email.text.trim().isEmpty ? null : _email.text.trim()
      ..notes = _notes.text.trim()
      ..lastUpdated = DateTime.now();
    Navigator.of(context).pop();
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
                      'Edit lead',
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
              const FieldLabel(label: 'First name', isRequired: true),
              TextField(controller: _firstName),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Last name'),
              TextField(controller: _lastName),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Phone', isRequired: true),
              TextField(controller: _phone),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Email'),
              TextField(controller: _email),
              const SizedBox(height: Insets.s16),
              const FieldLabel(label: 'Notes'),
              TextField(controller: _notes, maxLines: 3),
              const SizedBox(height: Insets.s20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleLogSheet extends StatelessWidget {
  final String title;

  const _SimpleLogSheet({required this.title});

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
