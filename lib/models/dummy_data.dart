import 'package:flutter/material.dart';

class Campaign {
  final String title;
  final int completed;
  final int total;

  Campaign({required this.title, required this.completed, required this.total});
}

class CrmTask {
  final String leadName;
  final String status;
  final String taskType;
  final String date;
  final Color statusColor;
  bool isCompleted;

  CrmTask({
    required this.leadName,
    required this.status,
    required this.taskType,
    required this.date,
    required this.statusColor,
    this.isCompleted = false,
  });
}

class DashboardMetric {
  final String label;
  final String value;

  DashboardMetric({required this.label, required this.value});
}

class DashboardBreakdown {
  final String label;
  final String value;
  final Color color;

  DashboardBreakdown({
    required this.label,
    required this.value,
    required this.color,
  });
}

class DummyData {
  static List<Campaign> campaigns = [
    Campaign(title: 'cold calling - sky hills', completed: 3, total: 5),
    Campaign(title: 'Azizi Venice', completed: 4, total: 5),
    Campaign(title: 'Sobha Hartland', completed: 17, total: 17),
    Campaign(title: 'Azizi Venice 3rd Phase', completed: 12, total: 12),
    Campaign(title: 'Damac Leads', completed: 55, total: 55),
    Campaign(title: 'Saqib - Property Portal Leads', completed: 7, total: 7),
    Campaign(title: 'Manual Leads - Past Re-Engagement', completed: 44, total: 44),
    Campaign(title: 'Cold Calling Sheet', completed: 2, total: 6),
  ];

  static List<CrmTask> todayTasks = [
    CrmTask(
      leadName: 'John Do',
      status: 'Working deal',
      taskType: 'Call back',
      date: 'Wed, 22 Jan 2025 04:02 PM',
      statusColor: const Color(0xFF9C27B0), // Purple
    ),
    CrmTask(
      leadName: 'Christiano',
      status: 'Lost deal',
      taskType: 'Meeting',
      date: 'Wed, 22 Jan 2025 04:03 PM',
      statusColor: const Color(0xFF9E9E9E), // Grey
    ),
    CrmTask(
      leadName: 'Abella Daniela',
      status: 'Future prospect',
      taskType: 'Send Whatsapp',
      date: 'Wed, 22 Jan 2025 04:03 PM',
      statusColor: const Color(0xFF00BCD4), // Cyan
    ),
    CrmTask(
      leadName: 'Sara',
      status: 'Qualified',
      taskType: 'Call back',
      date: 'Wed, 22 Jan 2025 04:59 PM',
      statusColor: const Color(0xFF4CAF50), // Green
    ),
  ];

  static List<DashboardMetric> metrics = [
    DashboardMetric(label: 'Total Leads', value: '250'),
    DashboardMetric(label: 'Contacted Leads', value: '106'),
    DashboardMetric(label: 'Pending Leads', value: '144'),
    DashboardMetric(label: 'Deals Closed', value: '3'),
  ];

  static List<DashboardBreakdown> breakdowns = [
    DashboardBreakdown(label: 'Qualified leads', value: '81', color: const Color(0xFF4CAF50)),
    DashboardBreakdown(label: 'Working deals', value: '6', color: const Color(0xFF9C27B0)),
    DashboardBreakdown(label: 'Deals closed', value: '3', color: const Color(0xFF1976D2)),
    DashboardBreakdown(label: 'Future prospect', value: '8', color: const Color(0xFF00BCD4)),
    DashboardBreakdown(label: 'Lost deals', value: '3', color: const Color(0xFF9E9E9E)),
    DashboardBreakdown(label: 'Did not respond', value: '1', color: const Color(0xFFFFC107)),
    DashboardBreakdown(label: 'Unqualified leads', value: '4', color: const Color(0xFFF44336)),
  ];
}
