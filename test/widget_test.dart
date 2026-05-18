import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jilani/models/dummy_data.dart';
import 'package:jilani/screens/campaign_call_now_screen.dart';
import 'package:jilani/screens/campaigns_screen.dart';
import 'package:jilani/screens/lead_detail_screen.dart';
import 'package:jilani/screens/lead_filter_screen.dart';
import 'package:jilani/screens/tasks_screen.dart';
import 'package:jilani/screens/wrap_up_screen.dart';
import 'package:jilani/theme/design_system.dart';

void main() {
  Widget wrapWithApp(Widget child) {
    return MaterialApp(theme: DesignSystem.themeData, home: child);
  }

  testWidgets('tapping a campaign call icon opens the call-now flow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(wrapWithApp(const CampaignsScreen()));

    await tester.tap(
      find.byKey(const ValueKey('campaign-call-cold calling - sky hills')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Call now'), findsOneWidget);
    expect(find.text('cold calling - sky hills'), findsAtLeastNWidgets(1));
    expect(find.text('1/5'), findsOneWidget);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('tapping a campaign body does not open the call-now flow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(wrapWithApp(const CampaignsScreen()));

    await tester.tap(
      find.byKey(const ValueKey('campaign-card-cold calling - sky hills')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Call now'), findsNothing);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('call-now screen shows current lead and progress', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final campaign = DummyData.campaigns.firstWhere(
      (campaign) => campaign.leads.isNotEmpty,
    );

    await tester.pumpWidget(
      wrapWithApp(CampaignCallNowScreen(campaign: campaign)),
    );

    expect(find.text('Call now'), findsOneWidget);
    expect(find.text(campaign.leads.first.name), findsOneWidget);
    expect(find.text('1/${campaign.leads.length}'), findsOneWidget);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('skip advances leads and exits after final lead', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final campaign = Campaign(
      title: 'First Campaign',
      completed: 0,
      total: 2,
      leads: const [
        CampaignLead(
          id: 'lead-1',
          campaignTitle: 'First Campaign',
          name: 'Saami Ibrahim',
          phone: '+1234567878',
          owner: 'Ali yawar',
        ),
        CampaignLead(
          id: 'lead-2',
          campaignTitle: 'First Campaign',
          name: 'Elena Rodriguez',
          phone: '+971501234567',
          owner: 'Ali yawar',
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: DesignSystem.themeData,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            CampaignCallNowScreen(campaign: campaign),
                      ),
                    );
                  },
                  child: const Text('Start campaign'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Start campaign'));
    await tester.pumpAndSettle();
    expect(find.text('Saami Ibrahim'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('skip-lead-button')));
    await tester.pumpAndSettle();
    expect(find.text('Elena Rodriguez'), findsOneWidget);
    expect(find.text('2/2'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('skip-lead-button')));
    await tester.pumpAndSettle();
    expect(find.text('Start campaign'), findsOneWidget);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('wrap-up save is disabled until required fields are selected', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final campaign = DummyData.campaigns.firstWhere(
      (campaign) => campaign.leads.isNotEmpty,
    );
    final lead = campaign.leads.first;

    await tester.pumpWidget(
      wrapWithApp(
        WrapUpScreen(
          campaign: campaign,
          lead: lead,
          currentIndex: 0,
          totalLeads: campaign.leads.length,
        ),
      ),
    );

    final disabledButton = tester.widget<ElevatedButton>(
      find.byKey(const ValueKey('save-and-call-next-button')),
    );
    expect(disabledButton.onPressed, isNull);

    await tester.ensureVisible(
      find.byKey(const ValueKey('call-outcome-field')),
    );
    await tester.tap(find.byKey(const ValueKey('call-outcome-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Answered').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('lead-status-field')));
    await tester.tap(find.byKey(const ValueKey('lead-status-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Qualified').last);
    await tester.pumpAndSettle();

    final enabledButton = tester.widget<ElevatedButton>(
      find.byKey(const ValueKey('save-and-call-next-button')),
    );
    expect(enabledButton.onPressed, isNotNull);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('task bottom sheet creates a local task for wrap-up', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final campaign = DummyData.campaigns.firstWhere(
      (campaign) => campaign.leads.isNotEmpty,
    );
    final lead = campaign.leads.first;

    await tester.pumpWidget(
      wrapWithApp(
        WrapUpScreen(
          campaign: campaign,
          lead: lead,
          currentIndex: 0,
          totalLeads: campaign.leads.length,
        ),
      ),
    );

    await tester.ensureVisible(find.byKey(const ValueKey('add-task-button')));
    await tester.tap(find.byKey(const ValueKey('add-task-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('task-type-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Call back').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('create-task-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Call back'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('lead filter panel shows selected count and applies filters', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));

    await tester.pumpWidget(
      wrapWithApp(const LeadFilterScreen(initialFilter: FilterState())),
    );

    await tester.tap(find.text('Status'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Working deal').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply').last);
    await tester.pumpAndSettle();

    expect(find.text('Apply (1)'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('completing a lead detail task removes it and shows add task', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final lead = DummyData.leads.first;
    final task = DummyData.tasks.firstWhere((task) => task.leadId == lead.id);
    task.status = 'Pending';
    task.isCompleted = false;
    addTearDown(() {
      task.status = 'Pending';
      task.isCompleted = false;
      tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(wrapWithApp(LeadDetailScreen(lead: lead)));

    await tester.ensureVisible(
      find.byKey(const ValueKey('complete-lead-task-button')),
    );
    await tester.tap(find.byKey(const ValueKey('complete-lead-task-button')));
    await tester.pumpAndSettle();

    expect(find.text('Send Whatsapp'), findsNothing);
    expect(find.text('Add task'), findsOneWidget);
  });

  testWidgets('tapping a task opens the matching lead detail page', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final task = DummyData.tasks.first;
    task
      ..status = 'Pending'
      ..isCompleted = false;

    await tester.pumpWidget(wrapWithApp(const TasksScreen()));

    await tester.tap(find.byKey(ValueKey('task-card-${task.id}')));
    await tester.pumpAndSettle();

    expect(find.text('Lead details'), findsOneWidget);
    expect(find.text(task.leadName), findsOneWidget);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('lead detail add task creates a local task', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final lead = DummyData.leads.first;
    final originalLength = DummyData.tasks.length;
    addTearDown(() {
      if (DummyData.tasks.length > originalLength) {
        DummyData.tasks.removeRange(originalLength, DummyData.tasks.length);
      }
      for (final task in DummyData.tasks.where(
        (task) => task.leadId == lead.id,
      )) {
        task.isCompleted = false;
      }
      tester.binding.setSurfaceSize(null);
    });

    for (final task in DummyData.tasks.where(
      (task) => task.leadId == lead.id,
    )) {
      task.isCompleted = true;
    }

    await tester.pumpWidget(wrapWithApp(LeadDetailScreen(lead: lead)));

    await tester.ensureVisible(
      find.byKey(const ValueKey('add-lead-detail-task-button')),
    );
    await tester.tap(find.byKey(const ValueKey('add-lead-detail-task-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('lead-detail-task-type-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Call back').last);
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('create-lead-detail-task-submit')),
    );
    await tester.pumpAndSettle();

    expect(DummyData.tasks.length, originalLength + 1);
    expect(DummyData.tasks.last.leadId, lead.id);
    expect(find.text('Call back'), findsOneWidget);
  });

  testWidgets('saving wrap-up advances to the next lead', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final campaign = Campaign(
      title: 'First Campaign',
      completed: 0,
      total: 2,
      leads: const [
        CampaignLead(
          id: 'lead-1',
          campaignTitle: 'First Campaign',
          name: 'Saami Ibrahim',
          phone: '+1234567878',
          owner: 'Ali yawar',
        ),
        CampaignLead(
          id: 'lead-2',
          campaignTitle: 'First Campaign',
          name: 'Elena Rodriguez',
          phone: '+971501234567',
          owner: 'Ali yawar',
        ),
      ],
    );

    await tester.pumpWidget(
      wrapWithApp(CampaignCallNowScreen(campaign: campaign)),
    );

    await tester.tap(find.byKey(const ValueKey('call-now-button')));
    await tester.pumpAndSettle();
    expect(find.text('Wrap up'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('call-outcome-field')),
    );
    await tester.tap(find.byKey(const ValueKey('call-outcome-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Answered').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('lead-status-field')));
    await tester.tap(find.byKey(const ValueKey('lead-status-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Qualified').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('save-and-call-next-button')));
    await tester.pumpAndSettle();

    expect(find.text('Call now'), findsOneWidget);
    expect(find.text('Elena Rodriguez'), findsOneWidget);
    expect(find.text('2/2'), findsOneWidget);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });
}
