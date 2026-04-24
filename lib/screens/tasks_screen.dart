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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: DesignSystem.primaryGold, width: 1.5),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/image_0.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.apartment,
                      color: DesignSystem.primaryGold,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: DesignSystem.primaryGold),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: DesignSystem.primaryGold),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 8, color: DesignSystem.statusBlue),
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
                    Icon(Icons.circle, size: 8, color: DesignSystem.statusPurple),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text(
                    'Found: ${DummyData.todayTasks.length}',
                    style: Theme.of(context).textTheme.labelLarge,
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
