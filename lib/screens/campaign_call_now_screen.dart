import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';
import '../widgets/crm_components.dart';
import 'wrap_up_screen.dart';

class CampaignCallNowScreen extends StatefulWidget {
  final Campaign campaign;

  const CampaignCallNowScreen({super.key, required this.campaign});

  @override
  State<CampaignCallNowScreen> createState() => _CampaignCallNowScreenState();
}

class _CampaignCallNowScreenState extends State<CampaignCallNowScreen> {
  final List<WrapUpResult> _results = [];
  int _currentIndex = 0;

  CampaignLead get _currentLead => widget.campaign.leads[_currentIndex];
  int get _totalLeads => widget.campaign.leads.length;

  void _finishSession() {
    Navigator.of(context).pop(List<WrapUpResult>.unmodifiable(_results));
  }

  void _advanceLead() {
    if (_totalLeads == 0 || _currentIndex >= _totalLeads - 1) {
      _finishSession();
      return;
    }

    setState(() => _currentIndex += 1);
  }

  Future<void> _tryLaunchLeadCall() async {
    final uri = Uri(scheme: 'tel', path: _currentLead.phone);

    try {
      final didLaunch = await launchUrl(uri);
      if (!didLaunch && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch ${_currentLead.phone}')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch ${_currentLead.phone}')),
      );
    }
  }

  Future<void> _callLead() async {
    unawaited(_tryLaunchLeadCall());

    if (!mounted) return;
    final result = await Navigator.of(context).push<WrapUpResult>(
      DesignSystem.route(
        WrapUpScreen(
          campaign: widget.campaign,
          lead: _currentLead,
          currentIndex: _currentIndex,
          totalLeads: _totalLeads,
        ),
      ),
    );

    if (result == null || !mounted) return;
    _results.add(result);
    _advanceLead();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.campaign.leads.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: const Center(child: Text('No leads in this campaign.')),
      );
    }

    final p = context.palette;
    final lead = _currentLead;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: ScreenBackdrop(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CampaignProgressHeader(
              campaignTitle: widget.campaign.title,
              currentIndex: _currentIndex,
              totalLeads: _totalLeads,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  Insets.s24,
                  Insets.s32,
                  Insets.s24,
                  Insets.s24,
                ),
                child: Column(
                  children: [
                    LeadAvatar(radius: 46, name: lead.name),
                    const SizedBox(height: Insets.s20),
                    Text(
                      lead.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lead.phone,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: p.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: Insets.s24),
                    if ((lead.notes ?? '').isNotEmpty) ...[
                      _ContextCard(notes: lead.notes!),
                      const SizedBox(height: Insets.s16),
                    ],
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Insets.s16),
                      decoration: BoxDecoration(
                        color: p.surfaceContainer,
                        borderRadius: BorderRadius.circular(Radii.md),
                        border: Border.all(color: p.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoField(
                            label: 'Email',
                            value: lead.email ?? '-',
                          ),
                          const SizedBox(height: Insets.s16),
                          InfoField(
                            label: 'Campaign',
                            value: lead.campaignTitle,
                          ),
                          const SizedBox(height: Insets.s16),
                          InfoField(label: 'Owner', value: lead.owner),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          Insets.s20,
          Insets.s8,
          Insets.s20,
          Insets.s20,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            key: const ValueKey('call-now-button'),
            onPressed: _callLead,
            icon: const Icon(Icons.call, size: 20),
            label: const Text('Call'),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final p = context.palette;
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text('Call now'),
      actions: [
        TextButton(
          key: const ValueKey('skip-lead-button'),
          onPressed: _advanceLead,
          child: Text(
            'Skip',
            style: DesignSystem.sans(
              color: p.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: p.divider, height: 1),
      ),
    );
  }
}

class _ContextCard extends StatelessWidget {
  final String notes;

  const _ContextCard({required this.notes});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: p.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.sm),
        border: Border.all(color: p.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: p.primaryContainer),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTEXT',
                      style: DesignSystem.sans(
                        color: p.primaryContainer,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notes,
                      style: DesignSystem.serif(
                        color: p.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
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

class _CampaignProgressHeader extends StatelessWidget {
  final String campaignTitle;
  final int currentIndex;
  final int totalLeads;

  const _CampaignProgressHeader({
    required this.campaignTitle,
    required this.currentIndex,
    required this.totalLeads,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.s20,
        vertical: Insets.s16,
      ),
      decoration: BoxDecoration(
        color: p.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: p.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              campaignTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: Insets.s12),
          Text(
            '${currentIndex + 1}/$totalLeads',
            style: DesignSystem.sans(
              color: p.primaryContainer,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
