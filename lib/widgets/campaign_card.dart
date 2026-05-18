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
    final p = context.palette;
    final progress =
        campaign.total == 0 ? 0.0 : campaign.completed / campaign.total;
    final canCall = campaign.leads.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: Insets.s12),
      padding: const EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: p.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: p.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: p.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(Radii.sm),
              border: Border.all(
                color: p.primaryContainer.withValues(alpha: 0.18),
              ),
            ),
            child: Icon(
              _campaignIcon(campaign.title),
              color: p.primaryContainer,
              size: 22,
            ),
          ),
          const SizedBox(width: Insets.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: p.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '${campaign.completed}/${campaign.total} Pending Leads',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: p.onSurfaceVariant,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Insets.s12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Radii.pill),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    value: progress,
                    color: p.primaryContainer,
                    backgroundColor: p.surfaceContainerHigh,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Insets.s12),
          Tooltip(
            message: canCall ? 'Start calling' : 'No pending leads',
            child: InkWell(
              key: ValueKey('campaign-call-${campaign.title}'),
              onTap: canCall ? onStartCalling : null,
              borderRadius: BorderRadius.circular(Radii.sm),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: canCall
                      ? p.primaryContainer
                      : p.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(Radii.sm),
                  border: Border.all(
                    color: canCall ? p.primaryContainer : p.outlineVariant,
                  ),
                ),
                child: Icon(
                  Icons.call,
                  color: canCall
                      ? p.onPrimaryContainer
                      : p.onSurfaceVariant.withValues(alpha: 0.45),
                  size: 21,
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
    if (lower.contains('sobha')) return Icons.home_work_outlined;
    if (lower.contains('portal')) return Icons.public;
    if (lower.contains('manual')) return Icons.list_alt;
    return Icons.phone_android;
  }
}
