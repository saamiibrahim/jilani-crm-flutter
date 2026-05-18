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
      DesignSystem.route(CampaignCallNowScreen(campaign: campaign)),
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
    final p = context.palette;
    final campaigns = DummyData.campaigns;
    return Scaffold(
      appBar: JilaniAppBar(
        showLogoTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ProfileButton(
            onTap: () {
              Navigator.of(context).push(
                DesignSystem.route<void>(const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: ScreenBackdrop(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: campaigns.isEmpty
                ? const _EmptyCampaigns()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      Insets.s20,
                      Insets.s24,
                      Insets.s20,
                      96,
                    ),
                    itemCount: campaigns.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Insets.s20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CAMPAIGNS',
                                      style: DesignSystem.sans(
                                        color: p.primaryContainer,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.6,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '$_pendingLeads Pending Leads',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: Insets.s12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: p.surfaceContainerHigh,
                                  borderRadius:
                                      BorderRadius.circular(Radii.sm),
                                  border:
                                      Border.all(color: p.outlineVariant),
                                ),
                                child: Text(
                                  '${campaigns.length} ACTIVE',
                                  style: DesignSystem.sans(
                                    color: p.primaryContainer,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final campaign = campaigns[index - 1];
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

class _EmptyCampaigns extends StatelessWidget {
  const _EmptyCampaigns();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.campaign_outlined, size: 44, color: p.onSurfaceVariant),
            const SizedBox(height: Insets.s16),
            Text(
              'No active campaigns',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Insets.s8),
            Text(
              'New campaigns will appear here once they are assigned to you.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: p.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
