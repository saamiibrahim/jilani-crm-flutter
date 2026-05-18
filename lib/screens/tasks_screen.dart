import 'package:flutter/material.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';
import '../widgets/crm_components.dart';
import 'lead_detail_screen.dart';
import 'settings_screen.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: JilaniAppBar(
          showLogoTitle: true,
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ProfileButton(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              ),
            ),
          ],
        ),
        body: ScreenBackdrop(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 18, 18, 10),
                child: _TaskTabBar(),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _TaskTabContent(
                      tasks: DummyData.tasks
                          .where((task) => task.status == 'Pending')
                          .toList(),
                    ),
                    _TaskTabContent(
                      tasks: DummyData.tasks
                          .where((task) => task.status == 'Overdue')
                          .toList(),
                    ),
                    _TaskTabContent(
                      tasks: DummyData.tasks
                          .where((task) => task.status == 'Pending')
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskTabBar extends StatelessWidget {
  const _TaskTabBar();

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicator: BoxDecoration(
        color: DesignSystem.primaryContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      labelColor: DesignSystem.onPrimaryContainer,
      unselectedLabelColor: DesignSystem.onSurfaceVariant,
      labelStyle: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      unselectedLabelStyle: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      tabs: const [
        _TaskTab(label: 'Today', dotColor: DesignSystem.onPrimaryContainer),
        _TaskTab(label: 'Overdue', dotColor: DesignSystem.statusRed),
        _TaskTab(label: 'Future', dotColor: Color(0xFF8A4DFF)),
      ],
    );
  }
}

class _TaskTab extends StatelessWidget {
  final String label;
  final Color dotColor;

  const _TaskTab({required this.label, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class _TaskTabContent extends StatefulWidget {
  final List<CrmTask> tasks;

  const _TaskTabContent({required this.tasks});

  @override
  State<_TaskTabContent> createState() => _TaskTabContentState();
}

class _TaskTabContentState extends State<_TaskTabContent> {
  CrmLead? _leadForTask(CrmTask task) {
    for (final lead in DummyData.leads) {
      if (lead.id == task.leadId) return lead;
    }
    return null;
  }

  Future<void> _openLead(CrmTask task) async {
    final lead = _leadForTask(task);
    if (lead == null) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => LeadDetailScreen(lead: lead)),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final visibleTasks = widget.tasks
        .where((task) => !task.isCompleted)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
          child: Text(
            'Found: ${visibleTasks.length}',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 96),
            itemCount: visibleTasks.length,
            itemBuilder: (context, index) {
              final task = visibleTasks[index];
              return _TaskListCard(task: task, onTap: () => _openLead(task));
            },
          ),
        ),
      ],
    );
  }
}

class _TaskListCard extends StatelessWidget {
  final CrmTask task;
  final VoidCallback onTap;

  const _TaskListCard({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey('task-card-${task.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: DesignSystem.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const LeadAvatar(radius: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.leadName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StatusChip(label: task.status, color: statusColor(task.status)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  task.taskType == 'Call back' ? Icons.call : Icons.chat,
                  color: DesignSystem.primaryContainer,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    task.taskType,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Due date\n${formatCrmDateTime(task.dueDate, task.dueTime)}',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
