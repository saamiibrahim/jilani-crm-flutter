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
    final p = context.palette;
    final done = task.isCompleted;
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
          GestureDetector(
            onTap: () => onChanged(!done),
            child: Container(
              margin: const EdgeInsets.only(top: 2, right: Insets.s16),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? p.primaryContainer : Colors.transparent,
                border: Border.all(
                  color: done
                      ? p.primaryContainer
                      : p.onSurfaceVariant.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: done
                  ? Icon(Icons.check, size: 16, color: p.onPrimaryContainer)
                  : null,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        task.leadName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: done
                                  ? p.onSurfaceVariant
                                  : p.onSurface,
                              fontWeight: FontWeight.w700,
                              decoration: done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: Insets.s8),
                    StatusChip(
                      label: task.status,
                      color: statusColor(task.status),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.s12),
                Row(
                  children: [
                    Icon(
                      task.taskType.toLowerCase().contains('call')
                          ? Icons.phone_in_talk
                          : (task.taskType.toLowerCase().contains('whatsapp')
                                ? Icons.chat_outlined
                                : Icons.groups_outlined),
                      color: p.onSurfaceVariant,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      flex: 0,
                      child: Text(
                        task.taskType,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: p.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: Insets.s8),
                    Icon(
                      Icons.calendar_today,
                      size: 13,
                      color: p.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        formatCrmDateTime(task.dueDate, task.dueTime),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: p.onSurfaceVariant,
                            ),
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
