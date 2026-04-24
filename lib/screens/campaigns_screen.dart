import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import '../widgets/campaign_card.dart';
import '../theme/design_system.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: DesignSystem.background,
      appBar: AppBar(
        // backgroundColor: DesignSystem.surfaceContainerLow,
        // shape: Border(
        //   bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        // ),
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
            icon: const Icon(
              Icons.search,
              color: DesignSystem.primaryContainer,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.person_outline,
              color: DesignSystem.primaryContainer,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 24.0,
              bottom: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'LIVE STATUS',
                    //   style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    //     color: DesignSystem.onSurfaceVariant,
                    //     letterSpacing: 1.5,
                    //     fontSize: 10,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    // const SizedBox(height: 6),
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
                    borderRadius: BorderRadius.circular(6),
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
                horizontal: 16.0,
                vertical: 8.0,
              ),
              itemCount: DummyData.campaigns.length,
              itemBuilder: (context, index) {
                final campaign = DummyData.campaigns[index];
                return CampaignCard(
                  campaign: campaign,
                  onStartCalling: () {
                    // Start calling flow
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
