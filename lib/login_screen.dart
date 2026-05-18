import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'theme/design_system.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AppState>().initialize(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.surface,
      body: Stack(
        children: [
          // Brand medallion watermark.
          Positioned(
            right: -90,
            top: -50,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.05,
                child: Image.asset(
                  'assets/logo-monogram.png',
                  width: 320,
                  height: 320,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: Insets.s24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Branding(palette: palette),
                        const SizedBox(height: Insets.s32),
                        _FormCard(
                          palette: palette,
                          children: [
                            _label('EMAIL ADDRESS', palette),
                            const SizedBox(height: Insets.s8),
                            _Field(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              hint: 'executive@jillani.com',
                              icon: Icons.alternate_email,
                              keyboardType: TextInputType.emailAddress,
                              palette: palette,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Please enter your email'
                                      : null,
                            ),
                            const SizedBox(height: Insets.s20),
                            _label('PASSWORD', palette),
                            const SizedBox(height: Insets.s8),
                            _Field(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              hint: '••••••••',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              palette: palette,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Please enter your password'
                                      : null,
                            ),
                            const SizedBox(height: Insets.s20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'FORGOT PASSWORD?',
                                  style: DesignSystem.sans(
                                    color: palette.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: Insets.s24),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _login,
                                child: Text(
                                  'SIGN IN',
                                  style: DesignSystem.sans(
                                    color: palette.onPrimaryContainer,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, JillaniPalette palette) {
    return Text(
      text,
      style: DesignSystem.sans(
        color: palette.onSurfaceVariant,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _Branding extends StatelessWidget {
  final JillaniPalette palette;
  const _Branding({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/jilani_logo.png',
          width: 72,
          height: 72,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: palette.primary, width: 1.5),
            ),
            child: Center(
              child: Text(
                'J',
                style: DesignSystem.serif(
                  color: palette.primary,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Insets.s16),
        Text(
          'Jillani Properties',
          textAlign: TextAlign.center,
          style: DesignSystem.serif(
            color: palette.onSurface,
            fontSize: 26,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        const SizedBox(height: Insets.s8),
        Text(
          'SALES',
          style: DesignSystem.sans(
            color: palette.primary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 4.0,
          ),
        ),
        const SizedBox(height: Insets.s12),
        Container(width: 64, height: 2, color: palette.primaryContainer),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  final JillaniPalette palette;
  final List<Widget> children;
  const _FormCard({required this.palette, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Insets.s24),
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.s24,
        vertical: Insets.s32,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: palette.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final JillaniPalette palette;
  final String? Function(String?) validator;

  const _Field({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.icon,
    required this.palette,
    required this.validator,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final focused = focusNode.hasFocus;
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: DesignSystem.sans(color: palette.onSurface, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: DesignSystem.sans(
          color: palette.onSurfaceVariant.withValues(alpha: 0.5),
          fontSize: 14,
        ),
        filled: true,
        fillColor: palette.surface.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Insets.s16,
          vertical: Insets.s16,
        ),
        suffixIcon: Icon(
          icon,
          size: 20,
          color: focused ? palette.primary : palette.outline,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: palette.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: palette.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: palette.primaryContainer),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: palette.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: palette.error),
        ),
      ),
      validator: validator,
    );
  }
}
