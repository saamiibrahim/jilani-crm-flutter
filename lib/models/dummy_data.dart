import 'package:flutter/material.dart';

class Campaign {
  final String title;
  int completed;
  final int total;
  final List<CampaignLead> leads;

  Campaign({
    required this.title,
    required this.completed,
    required this.total,
    required this.leads,
  });

  int get pending => (total - completed).clamp(0, total);
}

class CampaignLead {
  final String id;
  final String campaignTitle;
  final String name;
  final String phone;
  final String? email;
  final String? notes;
  final String owner;

  const CampaignLead({
    required this.id,
    required this.campaignTitle,
    required this.name,
    required this.phone,
    this.email,
    this.notes,
    required this.owner,
  });
}

class CrmLead {
  final String id;
  String firstName;
  String lastName;
  String phone;
  String? email;
  String owner;
  String campaign;
  String status;
  String source;
  String dealValue;
  String? notes;
  final List<String> labels;
  DateTime creationDate;
  DateTime lastUpdated;
  DateTime lastAssigned;

  CrmLead({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.email,
    required this.owner,
    required this.campaign,
    required this.status,
    required this.source,
    this.dealValue = '',
    this.notes,
    List<String>? labels,
    required this.creationDate,
    required this.lastUpdated,
    required this.lastAssigned,
  }) : labels = labels ?? [];

  String get name => '$firstName $lastName'.trim();

  CampaignLead toCampaignLead() {
    return CampaignLead(
      id: id,
      campaignTitle: campaign,
      name: name,
      phone: phone,
      email: email,
      notes: notes,
      owner: owner,
    );
  }
}

class WrapUpResult {
  final String leadId;
  final String callOutcome;
  final String leadStatus;
  final String dealValue;
  final String notes;
  final CrmTask? task;

  const WrapUpResult({
    required this.leadId,
    required this.callOutcome,
    required this.leadStatus,
    required this.dealValue,
    required this.notes,
    this.task,
  });

  bool get shouldAddTask => task != null;
}

class CrmTask {
  final String id;
  final String leadId;
  final String leadName;
  final String taskType;
  String status;
  final DateTime dueDate;
  final TimeOfDay dueTime;
  final String notes;
  final Color statusColor;

  CrmTask({
    required this.id,
    required this.leadId,
    required this.leadName,
    required this.taskType,
    required this.status,
    required this.dueDate,
    required this.dueTime,
    this.notes = '',
    required this.statusColor,
  });

  bool get isCompleted => status == 'Completed';

  set isCompleted(bool value) {
    status = value ? 'Completed' : 'Pending';
  }
}

class Activity {
  final String id;
  final String leadId;
  final IconData icon;
  final String type;
  final String title;
  final String notes;
  final String actor;
  final DateTime timestamp;
  final String? outcome;
  final Color color;

  const Activity({
    required this.id,
    required this.leadId,
    required this.icon,
    required this.type,
    required this.title,
    required this.notes,
    required this.actor,
    required this.timestamp,
    this.outcome,
    required this.color,
  });
}

class FilterState {
  final Set<String> statuses;
  final Set<String> sources;
  final Set<String> campaigns;
  final Set<String> dateFilters;
  final Set<String> dealValues;
  final Set<String> taskStatuses;
  final Set<String> taskTypes;

  const FilterState({
    this.statuses = const {},
    this.sources = const {},
    this.campaigns = const {},
    this.dateFilters = const {},
    this.dealValues = const {},
    this.taskStatuses = const {},
    this.taskTypes = const {},
  });

  int get selectedCount =>
      statuses.length +
      sources.length +
      campaigns.length +
      dateFilters.length +
      dealValues.length +
      taskStatuses.length +
      taskTypes.length;

  bool get isEmpty => selectedCount == 0;

  FilterState copyWith({
    Set<String>? statuses,
    Set<String>? sources,
    Set<String>? campaigns,
    Set<String>? dateFilters,
    Set<String>? dealValues,
    Set<String>? taskStatuses,
    Set<String>? taskTypes,
  }) {
    return FilterState(
      statuses: statuses ?? this.statuses,
      sources: sources ?? this.sources,
      campaigns: campaigns ?? this.campaigns,
      dateFilters: dateFilters ?? this.dateFilters,
      dealValues: dealValues ?? this.dealValues,
      taskStatuses: taskStatuses ?? this.taskStatuses,
      taskTypes: taskTypes ?? this.taskTypes,
    );
  }
}

class DashboardMetric {
  final String label;
  final String value;

  const DashboardMetric({required this.label, required this.value});
}

class DashboardBreakdown {
  final String label;
  final int value;
  final Color color;

  const DashboardBreakdown({
    required this.label,
    required this.value,
    required this.color,
  });
}

class DummyData {
  static const owners = ['Ali yawar', 'Imran javed', 'Hms'];
  static const leadStatuses = [
    'Qualified',
    'Working deal',
    'Deal closed',
    'Did not respond',
    'Lost deal',
    'Future prospect',
    'Unqualified',
  ];
  static const callOutcomes = ['Answered', 'Did not respond', 'Dead number'];
  static const taskTypes = [
    'Call back',
    'Send Whatsapp',
    'Meeting',
    'Send email',
    'Send text',
  ];

  static final List<CrmLead> leads = [
    CrmLead(
      id: 'lead-1',
      firstName: 'Saami',
      lastName: 'Ibrahim',
      phone: '+1234567878',
      email: 'saami.ibrahim@example.com',
      owner: 'Ali yawar',
      campaign: 'cold calling - sky hills',
      status: 'Working deal',
      source: 'CSV/Manual',
      dealValue: '1',
      notes: 'Interested in a family apartment and requested a quick call.',
      creationDate: DateTime(2026, 5, 5, 20, 31),
      lastUpdated: DateTime(2026, 5, 5, 20, 34),
      lastAssigned: DateTime(2026, 5, 5, 20, 32),
    ),
    CrmLead(
      id: 'lead-2',
      firstName: 'John',
      lastName: 'Doe',
      phone: '+1234566',
      owner: 'Ali yawar',
      campaign: 'Grhr',
      status: 'Deal closed',
      source: 'CSV/Manual',
      dealValue: '200',
      creationDate: DateTime(2026, 4, 26, 18),
      lastUpdated: DateTime(2026, 4, 29, 12),
      lastAssigned: DateTime(2026, 4, 29, 12),
    ),
    CrmLead(
      id: 'lead-3',
      firstName: 'Card Load',
      lastName: 'Urdu',
      phone: '+971501234567',
      owner: 'Hms',
      campaign: 'First Campaign',
      status: 'Working deal',
      source: 'Website',
      creationDate: DateTime(2026, 4, 26, 10),
      lastUpdated: DateTime(2026, 4, 26, 11),
      lastAssigned: DateTime(2026, 4, 26, 11),
    ),
  ];

  static final List<Campaign> campaigns = [
    Campaign(
      title: 'cold calling - sky hills',
      completed: 0,
      total: 5,
      leads: [
        leads[0].toCampaignLead(),
        CampaignLead(
          id: 'lead-4',
          campaignTitle: 'cold calling - sky hills',
          name: 'Elena Rodriguez',
          phone: '+971501234567',
          email: 'elena.rodriguez@example.com',
          notes: 'Asked for payment plan details.',
          owner: 'Ali yawar',
        ),
        CampaignLead(
          id: 'lead-5',
          campaignTitle: 'cold calling - sky hills',
          name: 'Marcus Sterling',
          phone: '+971509876543',
          notes: 'Prefers WhatsApp after the first call.',
          owner: 'Ali yawar',
        ),
        CampaignLead(
          id: 'lead-6',
          campaignTitle: 'cold calling - sky hills',
          name: 'Sophia Chen',
          phone: '+971505551234',
          email: 'sophia.chen@example.com',
          notes: 'Looking for handover timeline.',
          owner: 'Ali yawar',
        ),
        leads[2].toCampaignLead(),
      ],
    ),
    Campaign(
      title: 'Azizi Venice',
      completed: 1,
      total: 5,
      leads: [
        leads[1].toCampaignLead(),
        const CampaignLead(
          id: 'lead-7',
          campaignTitle: 'Azizi Venice',
          name: 'Anas Naeem',
          phone: '+971507779999',
          notes: 'Budget to be confirmed on call.',
          owner: 'Ali yawar',
        ),
        const CampaignLead(
          id: 'lead-8',
          campaignTitle: 'Azizi Venice',
          name: 'Reda Bona',
          phone: '+971503334444',
          owner: 'Ali yawar',
        ),
        const CampaignLead(
          id: 'lead-9',
          campaignTitle: 'Azizi Venice',
          name: 'Mohammed Farooq',
          phone: '+971508881111',
          owner: 'Ali yawar',
        ),
      ],
    ),
    Campaign(
      title: 'Sobha Hartland',
      completed: 9,
      total: 12,
      leads: [
        leads[0].toCampaignLead(),
        leads[2].toCampaignLead(),
      ],
    ),
    Campaign(
      title: 'Azizi Venice 3rd Phase',
      completed: 8,
      total: 10,
      leads: [leads[1].toCampaignLead()],
    ),
    Campaign(
      title: 'Saqib - Property Portal Leads',
      completed: 4,
      total: 7,
      leads: [leads[2].toCampaignLead()],
    ),
    Campaign(
      title: 'Manual Leads - Past Re-Engagement',
      completed: 16,
      total: 20,
      leads: [leads[0].toCampaignLead()],
    ),
  ];

  static final List<CrmTask> tasks = [
    CrmTask(
      id: 'task-1',
      leadId: 'lead-1',
      leadName: 'Saami Ibrahim',
      taskType: 'Send Whatsapp',
      status: 'Pending',
      dueDate: DateTime(2026, 5, 6),
      dueTime: const TimeOfDay(hour: 10, minute: 0),
      notes: 'asd',
      statusColor: const Color(0xFF8A4DFF),
    ),
    CrmTask(
      id: 'task-2',
      leadId: 'lead-2',
      leadName: 'John Doe',
      taskType: 'Call back',
      status: 'Overdue',
      dueDate: DateTime(2026, 4, 29),
      dueTime: const TimeOfDay(hour: 10, minute: 0),
      statusColor: const Color(0xFFE25A52),
    ),
  ];

  static final List<Activity> activities = [
    Activity(
      id: 'activity-1',
      leadId: 'lead-1',
      icon: Icons.monetization_on,
      type: 'deal',
      title: 'Deal value updated',
      notes: 'Deal Value set to 1 USD',
      actor: 'SYSTEM',
      timestamp: DateTime(2026, 5, 5, 20, 34),
      color: const Color(0xFFFFC928),
    ),
    Activity(
      id: 'activity-2',
      leadId: 'lead-1',
      icon: Icons.sync,
      type: 'status',
      title: "Status changed from 'Not Contacted' to 'Working Deal'",
      notes: '',
      actor: 'Ali yawar',
      timestamp: DateTime(2026, 5, 5, 20, 34),
      color: const Color(0xFF2F5AA8),
    ),
    Activity(
      id: 'activity-3',
      leadId: 'lead-1',
      icon: Icons.call,
      type: 'call',
      title: 'Lead contacted',
      notes: '',
      actor: 'Ali yawar',
      timestamp: DateTime(2026, 5, 5, 20, 34),
      outcome: 'Answered',
      color: const Color(0xFF45D067),
    ),
    Activity(
      id: 'activity-4',
      leadId: 'lead-1',
      icon: Icons.group,
      type: 'owner',
      title: 'Lead reassigned to Ali yawar',
      notes: '',
      actor: 'Imran javed',
      timestamp: DateTime(2026, 5, 5, 20, 32),
      color: const Color(0xFF2F5AA8),
    ),
  ];

  static List<DashboardMetric> get metrics => [
        DashboardMetric(label: 'Total Leads', value: leads.length.toString()),
        DashboardMetric(
          label: 'Contacted Leads',
          value: leads.where((lead) => lead.status != 'Qualified').length.toString(),
        ),
        DashboardMetric(
          label: 'Pending Leads',
          value: campaigns.fold<int>(0, (sum, campaign) => sum + campaign.pending).toString(),
        ),
        DashboardMetric(
          label: 'Deals Closed',
          value: leads.where((lead) => lead.status == 'Deal closed').length.toString(),
        ),
      ];

  static List<DashboardBreakdown> get statusBreakdowns => [
        const DashboardBreakdown(label: 'Qualified leads', value: 0, color: Color(0xFF4CAF50)),
        DashboardBreakdown(
          label: 'Working deals',
          value: leads.where((lead) => lead.status == 'Working deal').length,
          color: const Color(0xFF8A4DFF),
        ),
        DashboardBreakdown(
          label: 'Deals closed',
          value: leads.where((lead) => lead.status == 'Deal closed').length,
          color: const Color(0xFF2F5AA8),
        ),
        const DashboardBreakdown(label: 'Future prospect', value: 0, color: Color(0xFF00BCD4)),
        const DashboardBreakdown(label: 'Lost deals', value: 0, color: Color(0xFF9E9E9E)),
        const DashboardBreakdown(label: 'Did not respond', value: 0, color: Color(0xFFFFC928)),
        const DashboardBreakdown(label: 'Unqualified leads', value: 0, color: Color(0xFFE25A52)),
      ];

  static List<DashboardBreakdown> get callOutcomeBreakdowns => const [
        DashboardBreakdown(label: 'Answered', value: 0, color: Color(0xFF45D067)),
        DashboardBreakdown(label: 'Did not respond', value: 3, color: Color(0xFFFFC928)),
        DashboardBreakdown(label: 'Dead number', value: 1, color: Color(0xFFE25A52)),
      ];
}
