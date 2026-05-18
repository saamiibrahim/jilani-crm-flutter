import 'package:flutter/material.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';
import '../widgets/crm_components.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: JilaniAppBar(
          showLogoTitle: true,
          actions: [
            ProfileButton(
              onTap: () => Navigator.of(context).push(
                DesignSystem.route<void>(const SettingsScreen()),
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
                Container(height: 1, color: p.divider),
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
                    color: Color(0xFF2E6FB4),
                  ),
                  DashboardBreakdown(
                    label: 'TikTok',
                    value: 0,
                    color: Color(0xFF98A1B4),
                  ),
                  DashboardBreakdown(
                    label: 'Website',
                    value: 0,
                    color: Color(0xFF7B5BCB),
                  ),
                  DashboardBreakdown(
                    label: 'CSV/Manual',
                    value: 3,
                    color: Color(0xFFC9A24A),
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
      padding: const EdgeInsets.fromLTRB(
        Insets.s20,
        Insets.s20,
        Insets.s20,
        96,
      ),
      children: [
        _MetricGrid(metrics: metrics),
        const SizedBox(height: Insets.s16),
        _BreakdownCard(
          title: title,
          totalLabel: totalLabel,
          total: total,
          breakdowns: breakdowns,
        ),
        if (extraTitle != null) ...[
          const SizedBox(height: Insets.s16),
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

class _MetricGrid extends StatelessWidget {
  final List<DashboardMetric> metrics;

  const _MetricGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Insets.s12,
      crossAxisSpacing: Insets.s12,
      childAspectRatio: 1.7,
      children: [
        for (var i = 0; i < metrics.length; i++)
          _MetricCard(metric: metrics[i], accent: i == 0),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final DashboardMetric metric;
  final bool accent;

  const _MetricCard({required this.metric, required this.accent});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: accent
            ? p.primaryContainer.withValues(alpha: 0.14)
            : p.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(
          color: accent
              ? p.primaryContainer.withValues(alpha: 0.30)
              : p.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            metric.label.toUpperCase(),
            style: DesignSystem.sans(
              color: p.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            metric.value,
            style: DesignSystem.serif(
              color: p.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w700,
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
    final p = context.palette;
    final maxValue = breakdowns.fold<int>(
      1,
      (max, item) => item.value > max ? item.value : max,
    );

    return Container(
      padding: const EdgeInsets.all(Insets.s20),
      decoration: BoxDecoration(
        color: p.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: p.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (total != null)
                Text(
                  '$totalLabel: $total',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: p.onSurfaceVariant),
                ),
            ],
          ),
          const SizedBox(height: Insets.s20),
          ...breakdowns.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: Insets.s16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: Insets.s8),
                        decoration: BoxDecoration(
                          color: item.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.label,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        '${item.value}',
                        style: DesignSystem.serif(
                          color: p.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Insets.s8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Radii.pill),
                    child: LinearProgressIndicator(
                      minHeight: 5,
                      value: item.value == 0 ? 0 : item.value / maxValue,
                      color: item.color,
                      backgroundColor: p.surfaceContainerHigh,
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
