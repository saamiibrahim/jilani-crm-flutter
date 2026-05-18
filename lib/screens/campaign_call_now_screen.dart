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
      MaterialPageRoute(
        builder: (context) => WrapUpScreen(
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
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                child: LeadSummaryBlock(lead: _currentLead, onEdit: () {}),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: SizedBox(
          width: double.infinity,
          height: 58,
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: DesignSystem.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.white.withValues(alpha: 0.06),
          height: 1,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              campaignTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${currentIndex + 1}/$totalLeads',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: DesignSystem.primaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
