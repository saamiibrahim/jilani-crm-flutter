import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class LeadsScreen extends StatelessWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: DesignSystem.surfaceContainer,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.filter_list, size: 18, color: DesignSystem.primaryContainer),
                        const SizedBox(width: 8),
                        Text('Filter', style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: DesignSystem.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                        const Icon(Icons.keyboard_arrow_down, size: 18, color: DesignSystem.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: DesignSystem.surfaceContainer,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.sort, size: 18, color: DesignSystem.primaryContainer),
                        const SizedBox(width: 8),
                        Text('Newest first', style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: DesignSystem.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OVERVIEW',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                        letterSpacing: 1.5,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'TOTAL LEADS',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: DesignSystem.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: DesignSystem.surfaceContainerHigh.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Text(
                    '106 FOUND',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: DesignSystem.primaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 4, // Dummy count
              itemBuilder: (context, index) {
                return _buildLeadCard(context, index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: DesignSystem.primaryContainer,
        child: const Icon(Icons.person_add, color: DesignSystem.onPrimaryContainer),
      ),
    );
  }

  Widget _buildLeadCard(BuildContext context, int index) {
    final names = ['Aguilera Janea', 'Anas Naeem', 'Reda Bona', 'Mohammed'];
    final statuses = ['Qualified', 'Did not respond', 'Deal closed', 'Working deal'];
    final colors = [DesignSystem.statusGreen, DesignSystem.statusRed, DesignSystem.primaryContainer, Colors.deepPurpleAccent];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: DesignSystem.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: DesignSystem.primaryContainer, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    names[index % names.length],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: DesignSystem.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors[index % colors.length].withValues(alpha: 0.1),
                  border: Border.all(color: colors[index % colors.length].withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statuses[index % statuses.length].toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors[index % colors.length],
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag('Visit Done', DesignSystem.primaryContainer),
              if (index % 2 == 0) _buildTag('2BHK', DesignSystem.primaryContainer),
              if (index != 2) _buildTag('Studio', DesignSystem.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Last updated on Wed, Jan 22, 2025',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: DesignSystem.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
