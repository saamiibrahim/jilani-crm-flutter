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
  bool _isAdminView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Expanded(
              child: Text('PENDING LEADS', style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Text(
                'Admin',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Switch(
                value: _isAdminView,
                onChanged: (val) {
                  setState(() {
                    _isAdminView = val;
                  });
                },
                activeColor: DesignSystem.primaryGold,
                activeTrackColor: DesignSystem.primaryGold.withValues(alpha: 0.3),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: DesignSystem.primaryGold),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              '${DummyData.campaigns.fold<int>(0, (sum, item) => sum + item.completed)} PENDING LEADS',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: DesignSystem.statusRed,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
