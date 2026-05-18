import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../theme/design_system.dart';
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
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 40),
          children: [
            Text(
              'Profile details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 26),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 54,
                    backgroundColor: DesignSystem.surfaceContainerHigh,
                    child: Icon(
                      Icons.person,
                      color: DesignSystem.primaryContainer,
                      size: 38,
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: 2,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: DesignSystem.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: DesignSystem.onPrimaryContainer,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 34),
            const FieldLabel(label: 'Full name'),
            TextField(controller: _name),
            const SizedBox(height: 18),
            const FieldLabel(label: 'Email'),
            TextField(controller: _email),
            const SizedBox(height: 18),
            const FieldLabel(label: 'Phone'),
            TextField(controller: _phone),
            const SizedBox(height: 34),
            _SettingsRow(icon: Icons.key, label: 'Reset password', onTap: () {}),
            _SettingsRow(icon: Icons.help_outline, label: 'Help', onTap: () {}),
            _SettingsRow(icon: Icons.support_agent, label: 'Contact support', onTap: () {}),
            _SettingsRow(icon: Icons.privacy_tip_outlined, label: 'Privacy policy', onTap: () {}),
            _SettingsRow(icon: Icons.more_horiz, label: 'More', onTap: () {}),
            _SettingsRow(
              icon: Icons.logout,
              label: 'Logout',
              showChevron: false,
              onTap: () {
                context.read<AppState>().logout();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showChevron;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.showChevron = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: DesignSystem.primaryContainer),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      trailing: showChevron
          ? const Icon(Icons.chevron_right, color: DesignSystem.primaryContainer)
          : null,
      onTap: onTap,
    );
  }
}
