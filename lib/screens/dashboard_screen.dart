import 'package:flutter/material.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';
import '../widgets/crm_components.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: JilaniAppBar(
          showLogoTitle: true,
          actions: [
            ProfileButton(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(49),
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'MY PIPELINE'),
                    Tab(text: 'MY PRODUCTIVITY'),
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ],
            ),
          ),
        ),
        body: ScreenBackdrop(
          child: TabBarView(
            children: [
              _DashboardTab(
                metrics: DummyData.metrics,
                title: 'Status',
                totalLabel: 'Contacted leads',
                total: 2,
                breakdowns: DummyData.statusBreakdowns,
                extraTitle: 'Lead sources',
                extraBreakdowns: const [
                  DashboardBreakdown(
                    label: 'Facebook',
                    value: 0,
                    color: Color(0xFF1877F2),
                  ),
                  DashboardBreakdown(
                    label: 'TikTok',
                    value: 0,
                    color: Color(0xFF111111),
                  ),
                  DashboardBreakdown(
                    label: 'Website',
                    value: 0,
                    color: Color(0xFF7A3BD4),
                  ),
                  DashboardBreakdown(
                    label: 'CSV/Manual',
                    value: 3,
                    color: DesignSystem.primaryContainer,
                  ),
                ],
              ),
              _DashboardTab(
                metrics: const [
                  DashboardMetric(label: 'Calls Made', value: '4'),
                  DashboardMetric(label: 'Whatsapps Sent', value: '0'),
                  DashboardMetric(label: 'Emails Sent', value: '0'),
                  DashboardMetric(label: 'Texts Sent', value: '1'),
                ],
                title: 'Call outcomes',
                totalLabel: 'Calls made',
                total: 4,
                breakdowns: DummyData.callOutcomeBreakdowns,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final List<DashboardMetric> metrics;
  final String title;
  final String totalLabel;
  final int total;
  final List<DashboardBreakdown> breakdowns;
  final String? extraTitle;
  final List<DashboardBreakdown> extraBreakdowns;

  const _DashboardTab({
    required this.metrics,
    required this.title,
    required this.totalLabel,
    required this.total,
    required this.breakdowns,
    this.extraTitle,
    this.extraBreakdowns = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 96),
      children: [
        _AgentMetricCard(metrics: metrics),
        const SizedBox(height: 16),
        _BreakdownCard(
          title: title,
          totalLabel: totalLabel,
          total: total,
          breakdowns: breakdowns,
        ),
        if (extraTitle != null) ...[
          const SizedBox(height: 16),
          _BreakdownCard(
            title: extraTitle!,
            totalLabel: '',
            total: null,
            breakdowns: extraBreakdowns,
          ),
        ],
      ],
    );
  }
}

class _AgentMetricCard extends StatelessWidget {
  final List<DashboardMetric> metrics;

  const _AgentMetricCard({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DesignSystem.primaryContainer.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: DesignSystem.primaryContainer.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const LeadAvatar(radius: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ali yawar',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const Icon(
                Icons.workspace_premium,
                color: DesignSystem.primaryContainer,
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...metrics.map(
            (metric) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      metric.label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    metric.value,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: DesignSystem.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final String title;
  final String totalLabel;
  final int? total;
  final List<DashboardBreakdown> breakdowns;

  const _BreakdownCard({
    required this.title,
    required this.totalLabel,
    required this.total,
    required this.breakdowns,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = breakdowns.fold<int>(
      1,
      (max, item) => item.value > max ? item.value : max,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (total != null)
                Text(
                  '$totalLabel: $total',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          ...breakdowns.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(item.label)),
                      Text(
                        '${item.value}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 5,
                      value: item.value == 0 ? 0 : item.value / maxValue,
                      color: item.color,
                      backgroundColor: DesignSystem.surfaceContainerHigh,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
