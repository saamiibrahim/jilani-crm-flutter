import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/dummy_data.dart';
import '../theme/design_system.dart';

/// Brand medallion watermark — replaces the old dotted grid. Same constructor
/// so existing call sites keep working.
class DottedAccent extends StatelessWidget {
  final Alignment alignment;
  final double opacity;

  const DottedAccent({
    super.key,
    this.alignment = Alignment.topRight,
    this.opacity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: RepaintBoundary(
          child: Opacity(
            opacity: opacity,
            child: Image.asset(
              'assets/logo-monogram.png',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenBackdrop extends StatelessWidget {
  final Widget child;

  const ScreenBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          right: -70,
          bottom: -40,
          child: DottedAccent(alignment: Alignment.bottomRight, opacity: 0.04),
        ),
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
    final p = context.palette;
    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      titleSpacing: showBack ? 0 : null,
      title: showLogoTitle
          ? Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: p.primaryContainer.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(Radii.sm),
                    border: Border.all(
                      color: p.primaryContainer.withValues(alpha: 0.30),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/jilani_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.apartment,
                      color: p.primaryContainer,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'JILLANI PROPERTIES',
                    style: DesignSystem.sans(
                      color: p.primaryContainer,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
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
            child: Container(color: p.divider, height: 1),
          ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(right: Insets.s16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.sm),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: p.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(Radii.sm),
            border: Border.all(color: p.outlineVariant),
          ),
          child: Icon(Icons.person, color: p.primaryContainer, size: 19),
        ),
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;

  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bg = primary ? p.primaryContainer : p.surfaceContainer;
    final fg = primary ? p.onPrimaryContainer : p.primary;
    final labelColor = primary ? p.onPrimaryContainer : p.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.sm),
      child: Container(
        width: 84,
        height: 62,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Radii.sm),
          border: Border.all(
            color: primary ? p.primaryContainer : p.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg, size: 18),
            const SizedBox(height: 6),
            Text(
              label,
              style: DesignSystem.sans(
                color: labelColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
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
            primary: true,
            onTap: () => _launch(context, Uri(scheme: 'tel', path: lead.phone)),
          ),
          const SizedBox(width: Insets.s8),
          ActionTile(
            icon: Icons.chat_bubble_outline,
            label: 'WhatsApp',
            onTap: () => _launch(
              context,
              Uri.parse('https://wa.me/${lead.phone.replaceAll('+', '')}'),
            ),
          ),
          const SizedBox(width: Insets.s8),
          ActionTile(
            icon: Icons.calendar_today,
            label: 'Meeting',
            onTap: onMeeting ?? () {},
          ),
          const SizedBox(width: Insets.s8),
          ActionTile(
            icon: Icons.mode_comment_outlined,
            label: 'Comment',
            onTap: onComment ?? () {},
          ),
          const SizedBox(width: Insets.s8),
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
  final String? name;

  const LeadAvatar({super.key, this.radius = 22, this.name});

  String? get _initials {
    final n = name?.trim();
    if (n == null || n.isEmpty) return null;
    final parts = n.split(RegExp(r'\s+'));
    final letters = parts
        .where((s) => s.isNotEmpty)
        .map((s) => s[0])
        .take(2)
        .join();
    return letters.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final initials = _initials;
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: p.primaryContainer.withValues(alpha: 0.14),
        border: Border.all(
          color: p.primaryContainer.withValues(alpha: 0.28),
        ),
      ),
      alignment: Alignment.center,
      child: initials != null
          ? Text(
              initials,
              style: DesignSystem.serif(
                color: p.primary,
                fontSize: radius * 0.8,
                fontWeight: FontWeight.w700,
              ),
            )
          : Icon(Icons.person, color: p.primary, size: radius),
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
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: p.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: p.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LeadAvatar(radius: 24, name: lead.name),
              const SizedBox(width: Insets.s12),
              Expanded(
                child: Text(
                  lead.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (onAddLabel != null || onEdit != null) ...[
            const SizedBox(height: Insets.s12),
            Row(
              children: [
                if (onAddLabel != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onAddLabel!,
                      icon: const Icon(Icons.label_outline, size: 16),
                      label: const Text('Add label'),
                    ),
                  ),
                if (onAddLabel != null && onEdit != null)
                  const SizedBox(width: Insets.s8),
                if (onEdit != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit!,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit'),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: Insets.s16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 360) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoField(label: 'Phone', value: lead.phone),
                    const SizedBox(height: Insets.s12),
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
                  const SizedBox(width: Insets.s20),
                  Expanded(
                    child: InfoField(label: 'Email', value: lead.email ?? '-'),
                  ),
                ],
              );
            },
          ),
          if (showOwner) ...[
            const SizedBox(height: Insets.s12),
            InfoField(label: 'Owner', value: lead.owner),
          ],
          const SizedBox(height: Insets.s12),
          InfoField(label: 'Campaign', value: lead.campaignTitle),
          const SizedBox(height: Insets.s12),
          InfoField(label: 'Notes', value: lead.notes ?? '-'),
        ],
      ),
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
    final p = context.palette;
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          fixedSize: const Size(40, 40),
          minimumSize: const Size(40, 40),
          padding: EdgeInsets.zero,
          backgroundColor: filled ? p.surfaceContainerHigh : Colors.transparent,
          foregroundColor: filled ? p.primaryContainer : p.onSurface,
          side: filled ? null : BorderSide(color: p.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
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
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: DesignSystem.sans(
            color: p.primaryContainer,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: p.onSurface),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(color: color.withValues(alpha: 0.45)),
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
            style: DesignSystem.sans(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
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
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.s8),
      child: RichText(
        text: TextSpan(
          text: label.toUpperCase(),
          style: DesignSystem.sans(
            color: p.onSurfaceVariant,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
          children: [
            if (isRequired)
              TextSpan(
                text: '  *',
                style: TextStyle(color: p.primary),
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
  final Color? dotColor;

  const PickerField({
    super.key,
    required this.value,
    required this.hint,
    required this.onTap,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final hasValue = value != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.sm),
      child: InputDecorator(
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.keyboard_arrow_down, color: p.onSurfaceVariant),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Radii.sm),
            borderSide: BorderSide(
              color: hasValue && dotColor != null
                  ? dotColor!.withValues(alpha: 0.45)
                  : p.outlineVariant,
            ),
          ),
        ),
        child: Row(
          children: [
            if (dotColor != null && hasValue) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: Insets.s8),
            ],
            Expanded(
              child: Text(
                value ?? hint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: hasValue
                          ? p.onSurface
                          : p.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
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
  return DesignSystem.luxeSheet<String>(
    context: context,
    builder: (context) {
      final p = context.palette;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: Insets.s12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 1, color: p.divider),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = selected == option;
                    return ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? p.primary : p.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check, color: p.primary)
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

/// Lead / task status hues from the brand palette (colors_and_type.css).
/// Mid-tone, restrained, and readable on both the light and dark themes.
Color statusColor(String status) {
  switch (status) {
    case 'Qualified':
      return const Color(0xFF7B5BCB); // qualified — regal lavender
    case 'Working deal':
      return const Color(0xFFE0A23B); // negotiation — warm amber
    case 'Deal closed':
    case 'Completed':
      return const Color(0xFF2E9D63); // won — deep green
    case 'Did not respond':
      return const Color(0xFF2E6FB4); // info — quiet blue
    case 'Lost deal':
      return const Color(0xFF98A1B4); // lost — neutral
    case 'Future prospect':
      return const Color(0xFF2F8FB1); // viewing — dusty teal
    case 'Unqualified':
    case 'Overdue':
      return const Color(0xFFC0392B); // danger — terracotta
    default:
      return const Color(0xFFC9A24A); // gold — contacted / pending
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
