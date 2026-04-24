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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left side with icon and texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.list_alt, color: DesignSystem.statusGreen, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          campaign.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '${campaign.completed}',
                        style: const TextStyle(
                          color: DesignSystem.statusRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        ' / ${campaign.total} Pending Leads',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: DesignSystem.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Right side prominent start calling button
            SizedBox(
              width: 100,
              height: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onStartCalling,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone_in_talk, size: 24, color: DesignSystem.backgroundDark),
                    const SizedBox(height: 4),
                    Text(
                      'Start\ncalling',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: DesignSystem.backgroundDark,
                        fontSize: 12,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
