import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';

class DottedAccent extends StatelessWidget {
  final Alignment alignment;
  final double opacity;

  const DottedAccent({
    super.key,
    this.alignment = Alignment.topRight,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: RepaintBoundary(
          child: CustomPaint(
            size: const Size(180, 140),
            painter: _DottedAccentPainter(opacity: opacity),
          ),
        ),
      ),
    );
  }
}

class _DottedAccentPainter extends CustomPainter {
  final double opacity;

  const _DottedAccentPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DesignSystem.primaryContainer.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    for (var y = 10.0; y < size.height; y += 22) {
      for (var x = 10.0; x < size.width; x += 22) {
        canvas.drawCircle(Offset(x, y), 3.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedAccentPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}

class ScreenBackdrop extends StatelessWidget {
  final Widget child;

  const ScreenBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DottedAccent(alignment: Alignment.topRight, opacity: 0.12),
        const DottedAccent(alignment: Alignment.bottomLeft, opacity: 0.08),
        child,
      ],
    );
  }
}

class JilaniAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogoTitle;
  final bool showBack;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;

  const JilaniAppBar({
    super.key,
    this.title,
    this.showLogoTitle = false,
    this.showBack = false,
    this.actions = const [],
    this.bottom,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 1));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: showLogoTitle
          ? Row(
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
                Expanded(
                  child: Text(
                    'JILANI PROPERTIES',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: DesignSystem.primaryContainer,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          : Text(title ?? ''),
      actions: actions,
      bottom:
          bottom ??
          PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.white.withValues(alpha: 0.06),
              height: 1,
            ),
          ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: DesignSystem.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: DesignSystem.outlineVariant.withValues(alpha: 0.8),
            ),
          ),
          child: const Icon(
            Icons.person,
            color: DesignSystem.primaryContainer,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 82,
        height: 60,
        decoration: BoxDecoration(
          color: DesignSystem.primaryContainer,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: DesignSystem.onPrimaryContainer, size: 18),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: DesignSystem.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalActions extends StatelessWidget {
  final CampaignLead lead;
  final VoidCallback? onMeeting;
  final VoidCallback? onComment;
  final VoidCallback? onMore;

  const HorizontalActions({
    super.key,
    required this.lead,
    this.onMeeting,
    this.onComment,
    this.onMore,
  });

  Future<void> _launch(BuildContext context, Uri uri) async {
    try {
      await launchUrl(uri);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this action.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ActionTile(
            icon: Icons.call,
            label: 'Call',
            onTap: () => _launch(context, Uri(scheme: 'tel', path: lead.phone)),
          ),
          const SizedBox(width: 10),
          ActionTile(
            icon: Icons.chat_bubble,
            label: 'WhatsApp',
            onTap: () => _launch(
              context,
              Uri.parse('https://wa.me/${lead.phone.replaceAll('+', '')}'),
            ),
          ),
          const SizedBox(width: 10),
          ActionTile(
            icon: Icons.calendar_today,
            label: 'Meeting',
            onTap: onMeeting ?? () {},
          ),
          const SizedBox(width: 10),
          ActionTile(
            icon: Icons.comment,
            label: 'Comment',
            onTap: onComment ?? () {},
          ),
          const SizedBox(width: 10),
          ActionTile(
            icon: Icons.more_horiz,
            label: 'More',
            onTap: onMore ?? () {},
          ),
        ],
      ),
    );
  }
}

class LeadAvatar extends StatelessWidget {
  final double radius;

  const LeadAvatar({super.key, this.radius = 22});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: DesignSystem.surfaceContainerHigh,
      child: Icon(
        Icons.person,
        color: DesignSystem.primaryContainer,
        size: radius,
      ),
    );
  }
}

class LeadSummaryBlock extends StatelessWidget {
  final CampaignLead lead;
  final bool showOwner;
  final VoidCallback? onAddLabel;
  final VoidCallback? onEdit;

  const LeadSummaryBlock({
    super.key,
    required this.lead,
    this.showOwner = false,
    this.onAddLabel,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const LeadAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                lead.name,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onAddLabel != null) ...[
              const SizedBox(width: 8),
              CompactIconButton(
                tooltip: 'Add label',
                icon: Icons.label,
                onPressed: onAddLabel!,
              ),
            ],
            if (onEdit != null) ...[
              const SizedBox(width: 8),
              CompactIconButton(
                tooltip: 'Edit lead',
                icon: Icons.edit,
                filled: true,
                onPressed: onEdit!,
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 360) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoField(label: 'Phone', value: lead.phone),
                  const SizedBox(height: 14),
                  InfoField(label: 'Email', value: lead.email ?? '-'),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InfoField(label: 'Phone', value: lead.phone),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InfoField(label: 'Email', value: lead.email ?? '-'),
                ),
              ],
            );
          },
        ),
        if (showOwner) ...[
          const SizedBox(height: 14),
          InfoField(label: 'Owner', value: lead.owner),
        ],
        const SizedBox(height: 14),
        InfoField(label: 'Campaign', value: lead.campaignTitle),
        const SizedBox(height: 14),
        InfoField(label: 'Notes', value: lead.notes ?? '-'),
      ],
    );
  }
}

class CompactIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final bool filled;
  final VoidCallback onPressed;

  const CompactIconButton({
    super.key,
    required this.tooltip,
    required this.icon,
    this.filled = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          fixedSize: const Size(40, 40),
          minimumSize: const Size(40, 40),
          padding: EdgeInsets.zero,
          backgroundColor: filled
              ? DesignSystem.surfaceContainerHigh
              : Colors.transparent,
          foregroundColor: filled
              ? DesignSystem.primaryContainer
              : DesignSystem.onSurface,
          side: filled
              ? null
              : BorderSide(
                  color: DesignSystem.outlineVariant.withValues(alpha: 0.9),
                ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        icon: Icon(icon, size: 18),
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String label;
  final String value;

  const InfoField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: DesignSystem.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: DesignSystem.onSurface),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const FieldLabel({super.key, required this.label, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          children: [
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: DesignSystem.error),
              ),
          ],
        ),
      ),
    );
  }
}

class PickerField extends StatelessWidget {
  final String? value;
  final String hint;
  final VoidCallback onTap;

  const PickerField({
    super.key,
    required this.value,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: InputDecorator(
        decoration: const InputDecoration(
          suffixIcon: Icon(Icons.keyboard_arrow_down),
        ),
        child: Text(
          value ?? hint,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: value == null
                ? DesignSystem.onSurfaceVariant.withValues(alpha: 0.7)
                : DesignSystem.onSurface,
          ),
        ),
      ),
    );
  }
}

Future<String?> showOptionSheet({
  required BuildContext context,
  required String title,
  required List<String> options,
  String? selected,
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: DesignSystem.surfaceContainerLow,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: Text(option),
                      trailing: selected == option
                          ? const Icon(
                              Icons.check,
                              color: DesignSystem.primaryContainer,
                            )
                          : null,
                      onTap: () => Navigator.of(context).pop(option),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Color statusColor(String status) {
  switch (status) {
    case 'Qualified':
      return const Color(0xFF45D067);
    case 'Working deal':
      return const Color(0xFF8A4DFF);
    case 'Deal closed':
      return const Color(0xFF2F5AA8);
    case 'Did not respond':
      return const Color(0xFFFFC928);
    case 'Lost deal':
      return const Color(0xFF8A8E98);
    case 'Future prospect':
      return const Color(0xFF00BCD4);
    case 'Unqualified':
      return const Color(0xFFE25A52);
    case 'Overdue':
      return const Color(0xFFE25A52);
    default:
      return DesignSystem.primaryContainer;
  }
}

String formatCrmDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String formatCrmDateTime(DateTime date, TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year} $hour:$minute $period';
}
