import 'package:flutter/material.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';
import '../widgets/campaign_card.dart';
import '../widgets/crm_components.dart';
import 'campaign_call_now_screen.dart';
import 'settings_screen.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  int get _pendingLeads {
    return DummyData.campaigns.fold<int>(
      0,
      (sum, campaign) => sum + campaign.pending,
    );
  }

  Future<void> _openCallingSession(Campaign campaign) async {
    final results = await Navigator.push<List<WrapUpResult>>(
      context,
      MaterialPageRoute(
        builder: (context) => CampaignCallNowScreen(campaign: campaign),
      ),
    );

    if (!mounted || results == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Completed ${results.length} leads in ${campaign.title}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JilaniAppBar(
        showLogoTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ProfileButton(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: ScreenBackdrop(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
              itemCount: DummyData.campaigns.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CAMPAIGNS',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: DesignSystem.primaryContainer,
                                      letterSpacing: 1.4,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$_pendingLeads PENDING LEADS',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: DesignSystem.onSurface,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: DesignSystem.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: DesignSystem.outlineVariant.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                          child: Text(
                            '${DummyData.campaigns.length} ACTIVE',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: DesignSystem.primaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final campaign = DummyData.campaigns[index - 1];
                return CampaignCard(
                  key: ValueKey('campaign-card-${campaign.title}'),
                  campaign: campaign,
                  onStartCalling: () => _openCallingSession(campaign),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
