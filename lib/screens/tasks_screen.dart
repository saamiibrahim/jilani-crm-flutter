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
                DesignSystem.route<void>(const SettingsScreen()),
              ),
            ),
          ],
        ),
        body: ScreenBackdrop(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  Insets.s20,
                  Insets.s20,
                  Insets.s20,
                  Insets.s8,
                ),
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
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: p.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(color: p.outlineVariant),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: p.primaryContainer,
          borderRadius: BorderRadius.circular(Radii.pill),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: p.onPrimaryContainer,
        unselectedLabelColor: p.onSurfaceVariant,
        labelStyle: DesignSystem.sans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
        unselectedLabelStyle: DesignSystem.sans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
        tabs: const [
          _TaskTab(label: 'Today', dotColor: Color(0xFFC9A24A)),
          _TaskTab(label: 'Overdue', dotColor: Color(0xFFC0392B)),
          _TaskTab(label: 'Future', dotColor: Color(0xFF7B5BCB)),
        ],
      ),
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
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: Insets.s8),
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
      DesignSystem.route(LeadDetailScreen(lead: lead)),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final visibleTasks =
        widget.tasks.where((task) => !task.isCompleted).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Insets.s20,
            Insets.s12,
            Insets.s20,
            Insets.s12,
          ),
          child: Text(
            'Found: ${visibleTasks.length}',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: p.onSurfaceVariant),
          ),
        ),
        Expanded(
          child: visibleTasks.isEmpty
              ? const _EmptyTasks()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    Insets.s20,
                    0,
                    Insets.s20,
                    96,
                  ),
                  itemCount: visibleTasks.length,
                  itemBuilder: (context, index) {
                    final task = visibleTasks[index];
                    return _TaskListCard(
                      task: task,
                      onTap: () => _openLead(task),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.task_alt, size: 44, color: p.onSurfaceVariant),
            const SizedBox(height: Insets.s16),
            Text(
              'Nothing due here',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Insets.s8),
            Text(
              'Tasks you schedule will show up in this list.',
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

class _TaskListCard extends StatelessWidget {
  final CrmTask task;
  final VoidCallback onTap;

  const _TaskListCard({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return InkWell(
      key: ValueKey('task-card-${task.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.md),
      child: Container(
        margin: const EdgeInsets.only(bottom: Insets.s12),
        padding: const EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: p.surfaceContainer,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: p.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                LeadAvatar(radius: 18, name: task.leadName),
                const SizedBox(width: Insets.s12),
                Expanded(
                  child: Text(
                    task.leadName,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StatusChip(label: task.status, color: statusColor(task.status)),
              ],
            ),
            const SizedBox(height: Insets.s16),
            Row(
              children: [
                Icon(
                  task.taskType == 'Call back' ? Icons.call : Icons.chat,
                  color: p.primaryContainer,
                  size: 18,
                ),
                const SizedBox(width: Insets.s8),
                Expanded(
                  child: Text(
                    task.taskType,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Insets.s12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Due  ${formatCrmDateTime(task.dueDate, task.dueTime)}',
                textAlign: TextAlign.right,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: p.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
