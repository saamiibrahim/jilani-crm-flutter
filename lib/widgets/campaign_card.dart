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
    // Get progress percentage
    final double progress = campaign.total > 0 ? campaign.completed / campaign.total : 0.0;
    
    // Choose icon based on title to simulate the design
    IconData cardIcon = Icons.phone_in_talk;
    if (campaign.title.contains('Facebook')) { cardIcon = Icons.filter_none; }
    else if (campaign.title.contains('Azizi')) { cardIcon = Icons.location_city; }
    else if (campaign.title.contains('Sobha')) { cardIcon = Icons.home_work; }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Box
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: DesignSystem.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(cardIcon, color: DesignSystem.primaryContainer, size: 24),
          ),
          const SizedBox(width: 16),
          
          // Middle Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  campaign.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: DesignSystem.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: progress == 0 ? DesignSystem.primaryContainer.withValues(alpha: 0.4) : DesignSystem.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${campaign.completed}/${campaign.total} Pending Leads',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Progress Bar
                Container(
                  height: 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: DesignSystem.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: DesignSystem.primaryContainer,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: DesignSystem.primaryContainer.withValues(alpha: 0.4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Right Call Button
          InkWell(
            onTap: onStartCalling,
            borderRadius: BorderRadius.circular(12), // rounded-xl
            child: Container(
              width: 56, // 24 icon + 16 padding on each side (p-4)
              height: 56,
              decoration: BoxDecoration(
                color: DesignSystem.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: DesignSystem.primaryContainer.withValues(alpha: 0.15),
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.call,
                color: DesignSystem.onPrimaryContainer,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
