import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import '../theme/design_system.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
              icon: const Icon(Icons.search, color: DesignSystem.primaryContainer),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: DesignSystem.primaryContainer),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
          bottom: TabBar(
            indicatorColor: DesignSystem.primaryContainer,
            labelColor: DesignSystem.primaryContainer,
            unselectedLabelColor: DesignSystem.onSurfaceVariant,
            indicatorWeight: 3,
            dividerColor: Colors.white.withValues(alpha: 0.05),
            labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
            tabs: const [
              Tab(text: 'MY PIPELINE'),
              Tab(text: 'MY PRODUCTIVITY'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pipeline Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile and Top Stats
                  Container(
                    decoration: BoxDecoration(
                      color: DesignSystem.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: DesignSystem.surfaceContainerHigh,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.person, color: DesignSystem.primaryContainer, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'sandesha',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: DesignSystem.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.workspace_premium, color: DesignSystem.primaryContainer),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...DummyData.metrics.map((metric) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                metric.label,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: DesignSystem.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                metric.value,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: DesignSystem.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Status Breakdown Section
                  Container(
                    decoration: BoxDecoration(
                      color: DesignSystem.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'STATUS',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: DesignSystem.onSurfaceVariant,
                                  letterSpacing: 1.5,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: DesignSystem.surfaceContainerHigh.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                ),
                                child: Text(
                                  '106 CONTACTED',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: DesignSystem.primaryContainer,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: DummyData.breakdowns.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = DummyData.breakdowns[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.label, 
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          color: DesignSystem.onSurface,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        item.value,
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          color: DesignSystem.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Progress bar indicator
                                  Stack(
                                    children: [
                                      Container(
                                        height: 4,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      Container(
                                        height: 4,
                                        width: MediaQuery.of(context).size.width * (int.parse(item.value) / 150.0).clamp(0.0, 1.0),
                                        decoration: BoxDecoration(
                                          color: item.color,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Productivity Tab
            const Center(child: Text('Productivity Data Here')),
          ],
        ),
      ),
    );
  }
}
