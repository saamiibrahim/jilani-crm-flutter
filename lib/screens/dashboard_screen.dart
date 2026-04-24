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
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline, color: DesignSystem.primaryGold),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            tabs: [
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
                      color: const Color(0xFFFAFAD2), // Light yellow bg from image
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Color(0xFFE8EAF6),
                                  child: Icon(Icons.person, color: Colors.indigo, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'sandesha',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.workspace_premium, color: DesignSystem.primaryGold),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...DummyData.metrics.map((metric) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                metric.label,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                metric.value,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.black87,
                                  fontFamily: 'Playfair Display', // Enforcing Playfair
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
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                              ),
                              Text(
                                'Contacted leads: 106',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: DesignSystem.textSecondary,
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
                                      Text(item.label, style: Theme.of(context).textTheme.bodyMedium),
                                      Text(
                                        item.value,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontSize: 16,
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
