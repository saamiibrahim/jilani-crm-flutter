import 'package:flutter/material.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onStartCalling;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.onStartCalling,
  });

  @override
  Widget build(BuildContext context) {
    final progress = campaign.total == 0
        ? 0.0
        : campaign.completed / campaign.total;
    final canCall = campaign.leads.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: DesignSystem.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: DesignSystem.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: DesignSystem.primaryContainer.withValues(alpha: 0.12),
              ),
            ),
            child: Icon(
              _campaignIcon(campaign.title),
              color: DesignSystem.primaryContainer,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: DesignSystem.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${campaign.completed}/${campaign.total} Pending Leads',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    value: progress,
                    color: DesignSystem.primaryContainer,
                    backgroundColor: DesignSystem.surfaceContainerHigh,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Tooltip(
            message: canCall ? 'Start calling' : 'No pending leads',
            child: InkWell(
              key: ValueKey('campaign-call-${campaign.title}'),
              onTap: canCall ? onStartCalling : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: canCall
                      ? DesignSystem.primaryContainer
                      : DesignSystem.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: canCall
                        ? DesignSystem.primaryContainer
                        : DesignSystem.outlineVariant,
                  ),
                ),
                child: Icon(
                  Icons.call,
                  color: canCall
                      ? DesignSystem.onPrimaryContainer
                      : DesignSystem.onSurfaceVariant.withValues(alpha: 0.45),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _campaignIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('azizi') || lower.contains('sky')) {
      return Icons.apartment;
    }
    if (lower.contains('sobha')) return Icons.home_work;
    if (lower.contains('portal')) return Icons.public;
    if (lower.contains('manual')) return Icons.list_alt;
    return Icons.phone_android;
  }
}
