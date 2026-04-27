import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import '../widgets/campaign_card.dart';
import '../theme/design_system.dart';
import 'wrap_up_screen.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'JILANI PROPERTIES',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: DesignSystem.primaryContainer,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: DesignSystem.primaryContainer.withValues(alpha: 0.3),
              ),
            ),
            child: const ClipOval(
              child: Icon(
                Icons.person,
                color: DesignSystem.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.white.withValues(alpha: 0.05),
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 16.0,
              bottom: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Campaigns',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                        letterSpacing: 1.5,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'PENDING LEADS',
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: DesignSystem.surfaceContainerHigh.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Text(
                    '${DummyData.campaigns.fold<int>(0, (sum, item) => sum + item.completed)} TOTAL',
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              itemCount: DummyData.campaigns.length,
              itemBuilder: (context, index) {
                final campaign = DummyData.campaigns[index];
                return CampaignCard(
                  campaign: campaign,
                  onStartCalling: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WrapUpScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
