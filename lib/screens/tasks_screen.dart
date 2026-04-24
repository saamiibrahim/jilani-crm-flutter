import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import '../widgets/task_item_tile.dart';
import '../theme/design_system.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/jilani_logo.png',
                width: 36,
                height: 36,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.apartment,
                  color: DesignSystem.primaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'JILANI CRM',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: DesignSystem.primaryContainer,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: DesignSystem.primaryContainer),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: DesignSystem.primaryContainer),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
          bottom: TabBar(
            indicatorColor: DesignSystem.primaryContainer,
            labelColor: DesignSystem.primaryContainer,
            unselectedLabelColor: DesignSystem.onSurfaceVariant,
            indicatorWeight: 3,
            dividerColor: Colors.white.withValues(alpha: 0.05),
            labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 8),
                    SizedBox(width: 8),
                    Text('Today'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 8, color: DesignSystem.statusRed),
                    SizedBox(width: 8),
                    Text('Overdue'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 8),
                    SizedBox(width: 8),
                    Text('Future'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Today Tab
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OVERVIEW',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: DesignSystem.onSurfaceVariant,
                              letterSpacing: 1.5,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'TODAY\'S TASKS',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: DesignSystem.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: DesignSystem.surfaceContainerHigh.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: Text(
                          '${DummyData.todayTasks.length} FOUND',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: DesignSystem.primaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: DummyData.todayTasks.length,
                    itemBuilder: (context, index) {
                      final task = DummyData.todayTasks[index];
                      return TaskItemTile(
                        task: task,
                        onChanged: (val) {
                          setState(() {
                            task.isCompleted = val ?? false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            // Overdue Tab
            const Center(child: Text('No overdue tasks.')),
            // Future Tab
            const Center(child: Text('No future tasks.')),
          ],
        ),
      ),
    );
  }
}
