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
            IconButton(
              icon: const Icon(Icons.search, color: DesignSystem.primaryContainer),
              onPressed: () {},
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: DesignSystem.primaryContainer.withValues(alpha: 0.3)),
              ),
              child: const ClipOval(
                child: Icon(Icons.person, color: DesignSystem.onSurfaceVariant, size: 20),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(49.0), // 48 for TabBar + 1 for border
            child: Column(
              children: [
                TabBar(
                  indicatorColor: DesignSystem.primaryContainer,
                  labelColor: DesignSystem.primaryContainer,
                  unselectedLabelColor: DesignSystem.onSurfaceVariant,
                  indicatorWeight: 3,
                  dividerColor: Colors.transparent,
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
                Container(
                  color: Colors.white.withValues(alpha: 0.05),
                  height: 1.0,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Pipeline Tab
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard Overview',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 24),
                  
                  // User Profile and Top Stats
                  Container(
                    decoration: BoxDecoration(
                      color: DesignSystem.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
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
                                  'Alexander Agent',
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
                                  color: DesignSystem.primaryContainer,
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
                      borderRadius: BorderRadius.circular(8),
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
                                          color: DesignSystem.primaryContainer,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
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
