import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import '../theme/design_system.dart';
import 'crm_components.dart';

class TaskItemTile extends StatelessWidget {
  final CrmTask task;
  final ValueChanged<bool?> onChanged;

  const TaskItemTile({super.key, required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Checkbox
          GestureDetector(
            onTap: () => onChanged(!task.isCompleted),
            child: Container(
              margin: const EdgeInsets.only(top: 2, right: 16),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted
                    ? DesignSystem.primaryContainer
                    : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted
                      ? DesignSystem.primaryContainer
                      : DesignSystem.onSurfaceVariant.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: DesignSystem.onPrimaryContainer,
                    )
                  : null,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Status Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        task.leadName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: task.isCompleted
                              ? DesignSystem.onSurfaceVariant
                              : DesignSystem.onSurface,
                          fontWeight: FontWeight.w500,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: DesignSystem.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: task.isCompleted
                              ? Colors.white.withValues(alpha: 0.05)
                              : task.statusColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: task.statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            task.status.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: task.isCompleted
                                      ? Colors.white70
                                      : task.statusColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Task Type and Date Row
                Row(
                  children: [
                    Icon(
                      task.taskType.toLowerCase().contains('call')
                          ? Icons.phone_in_talk
                          : (task.taskType.toLowerCase().contains('whatsapp')
                                ? Icons.message
                                : Icons.group),
                      color: DesignSystem.onSurfaceVariant,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      flex: 0,
                      child: Text(
                        task.taskType,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: DesignSystem.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: DesignSystem.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        formatCrmDateTime(task.dueDate, task.dueTime),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: DesignSystem.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
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
