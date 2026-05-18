import 'package:flutter/material.dart';
import 'campaigns_screen.dart';
import 'tasks_screen.dart';
import 'leads_screen.dart';
import 'dashboard_screen.dart';
import '../theme/design_system.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final Set<int> _builtTabs = {0};

  Widget _screenForIndex(int index) {
    return switch (index) {
      0 => const CampaignsScreen(),
      1 => const TasksScreen(),
      2 => const LeadsScreen(),
      3 => const DashboardScreen(),
      _ => const CampaignsScreen(),
    };
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
      _builtTabs.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(4, (index) {
          if (!_builtTabs.contains(index)) {
            return const SizedBox.shrink();
          }
          final isActive = _currentIndex == index;
          return Offstage(
            offstage: !isActive,
            child: TickerMode(enabled: isActive, child: _screenForIndex(index)),
          );
        }),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.palette.surfaceContainerLow,
          border: Border(
            top: BorderSide(color: context.palette.divider),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconSize: 23,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_outlined),
              activeIcon: Icon(Icons.campaign),
              label: 'CAMPAIGNS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_outlined),
              activeIcon: Icon(Icons.task_alt),
              label: 'TASKS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              activeIcon: Icon(Icons.group),
              label: 'LEADS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'DASHBOARD',
            ),
          ],
        ),
      ),
    );
  }
}
