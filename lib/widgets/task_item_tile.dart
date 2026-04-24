import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import '../theme/design_system.dart';

class TaskItemTile extends StatelessWidget {
  final CrmTask task;
  final ValueChanged<bool?> onChanged;

  const TaskItemTile({
    super.key,
    required this.task,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: onChanged,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, color: DesignSystem.textSecondary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            task.leadName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: task.statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: task.statusColor.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: task.statusColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              task.status,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: task.statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            task.taskType.toLowerCase().contains('call')
                                ? Icons.phone
                                : (task.taskType.toLowerCase().contains('whatsapp')
                                    ? Icons.message
                                    : Icons.people),
                            color: DesignSystem.statusGreen,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            task.taskType,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Due date',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            task.date,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: DesignSystem.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
