import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../theme/design_system.dart';
import '../theme_controller.dart';
import '../widgets/crm_components.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _name = TextEditingController(text: 'Ali yawar');
  final _email = TextEditingController(text: 'w5ikoi6jwe@xxxkud.com');
  final _phone = TextEditingController(text: '1224455');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      appBar: JilaniAppBar(
        title: 'Settings',
        showBack: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Save'),
          ),
        ],
      ),
      body: ScreenBackdrop(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Insets.s20,
            Insets.s24,
            Insets.s20,
            Insets.s32,
          ),
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: p.primaryContainer.withValues(alpha: 0.14),
                      border: Border.all(
                        color: p.primaryContainer.withValues(alpha: 0.30),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'AY',
                      style: DesignSystem.serif(
                        color: p.primary,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: 0,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: p.primaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(color: p.surface, width: 2),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: p.onPrimaryContainer,
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Insets.s32),
            const FieldLabel(label: 'Profile details'),
            const SizedBox(height: Insets.s16),
            const FieldLabel(label: 'Full name'),
            TextField(controller: _name),
            const SizedBox(height: Insets.s16),
            const FieldLabel(label: 'Email'),
            TextField(controller: _email),
            const SizedBox(height: Insets.s16),
            const FieldLabel(label: 'Phone'),
            TextField(controller: _phone),
            const SizedBox(height: Insets.s24),
            const FieldLabel(label: 'Appearance'),
            const SizedBox(height: Insets.s12),
            const _ThemeModeSelector(),
            const SizedBox(height: Insets.s24),
            const FieldLabel(label: 'Account'),
            const SizedBox(height: Insets.s8),
            _SettingsCard(
              children: [
                _SettingsRow(
                  icon: Icons.key,
                  label: 'Reset password',
                  onTap: () {},
                ),
                _SettingsRow(
                  icon: Icons.help_outline,
                  label: 'Help',
                  onTap: () {},
                ),
                _SettingsRow(
                  icon: Icons.support_agent,
                  label: 'Contact support',
                  onTap: () {},
                ),
                _SettingsRow(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy policy',
                  onTap: () {},
                ),
                _SettingsRow(
                  icon: Icons.more_horiz,
                  label: 'More',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: Insets.s16),
            _SettingsCard(
              children: [
                _SettingsRow(
                  icon: Icons.logout,
                  label: 'Logout',
                  destructive: true,
                  showChevron: false,
                  onTap: () {
                    context.read<AppState>().logout();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i != children.length - 1) {
        rows.add(Divider(height: 1, color: p.divider, indent: 52));
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: p.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: p.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: rows),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showChevron;
  final bool destructive;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.showChevron = true,
    this.destructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = destructive ? p.error : p.primaryContainer;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: destructive ? p.error : p.onSurface,
            ),
      ),
      trailing: showChevron
          ? Icon(Icons.chevron_right, color: p.onSurfaceVariant, size: 20)
          : null,
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final controller = context.watch<ThemeController>();
    const modes = [
      (ThemeMode.light, 'Light', Icons.light_mode_outlined),
      (ThemeMode.dark, 'Dark', Icons.dark_mode_outlined),
      (ThemeMode.system, 'System', Icons.brightness_auto_outlined),
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: p.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.sm),
        border: Border.all(color: p.outlineVariant),
      ),
      child: Row(
        children: [
          for (final (mode, label, icon) in modes)
            Expanded(
              child: GestureDetector(
                onTap: () => context.read<ThemeController>().setMode(mode),
                child: AnimatedContainer(
                  duration: Motion.fast,
                  curve: Motion.ease,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.mode == mode
                        ? p.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        icon,
                        size: 18,
                        color: controller.mode == mode
                            ? p.onPrimaryContainer
                            : p.onSurfaceVariant,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: DesignSystem.sans(
                          color: controller.mode == mode
                              ? p.onPrimaryContainer
                              : p.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
