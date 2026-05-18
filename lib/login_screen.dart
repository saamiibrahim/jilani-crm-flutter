import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Scaffold(
      backgroundColor: DesignSystem.background,
      body: Stack(
        children: [
          // ── Ambient Background Glows ──
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DesignSystem.primaryContainer.withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DesignSystem.surfaceContainerHigh.withValues(alpha: 0.30),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Main Content ──
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Branding Section ──
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 20),
                          child: Column(
                            children: [
                              // Logo
                              Image.asset(
                                'assets/jilani_logo.png',
                                width: 72,
                                height: 72,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: DesignSystem.primaryContainer,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'J',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700,
                                          color: DesignSystem.primaryContainer,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              // Title
                              Text(
                                'JILANI\nPROPERTIES',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: DesignSystem.primary,
                                  letterSpacing: 20 * 0.15, // tighter tracking
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Gold Divider Bar
                              Container(
                                width: 72,
                                height: 2,
                                color: DesignSystem.primaryContainer,
                              ),
                            ],
                          ),
                        ),

                        // ── Form Card ──
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 28,
                              ),
                              decoration: BoxDecoration(
                                color: DesignSystem.surfaceContainerLow
                                    .withValues(alpha: 0.40),
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                    color: DesignSystem.outlineVariant
                                        .withValues(alpha: 0.30),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // ── Email Field ──
                                  _buildFieldLabel('EMAIL ADDRESS'),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    controller: _emailController,
                                    focusNode: _emailFocus,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: DesignSystem.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'executive@jillani.com',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        color:
                                            DesignSystem.surfaceContainerHigh,
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFF070F17)
                                          .withValues(
                                            alpha: 0.50,
                                          ), // surface-container-lowest/50
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      border: InputBorder.none,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: DesignSystem.outlineVariant
                                              .withValues(alpha: 0.50),
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: DesignSystem.primaryContainer,
                                          width: 1,
                                        ),
                                      ),
                                      errorBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: DesignSystem.error,
                                        ),
                                      ),
                                      focusedErrorBorder:
                                          const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: DesignSystem.error,
                                            ),
                                          ),
                                      suffixIcon: Icon(
                                        Icons.alternate_email,
                                        size: 20,
                                        color: _emailFocus.hasFocus
                                            ? DesignSystem.primaryContainer
                                            : DesignSystem.outlineVariant,
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // ── Password Field ──
                                  _buildFieldLabel('PASSWORD'),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    obscureText: true,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: DesignSystem.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        color:
                                            DesignSystem.surfaceContainerHigh,
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: const Color(
                                        0xFF070F17,
                                      ).withValues(alpha: 0.50),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      border: InputBorder.none,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: DesignSystem.outlineVariant
                                              .withValues(alpha: 0.50),
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: DesignSystem.primaryContainer,
                                          width: 1,
                                        ),
                                      ),
                                      errorBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: DesignSystem.error,
                                        ),
                                      ),
                                      focusedErrorBorder:
                                          const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: DesignSystem.error,
                                            ),
                                          ),
                                      suffixIcon: Icon(
                                        Icons.lock_outline,
                                        size: 20,
                                        color: _passwordFocus.hasFocus
                                            ? DesignSystem.primaryContainer
                                            : DesignSystem.outlineVariant,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),

                                  // ── Forgot Password ──
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'FORGOT PASSWORD?',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing:
                                              10 * 0.1, // widest tracking
                                          color: DesignSystem.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // ── Sign In Button ──
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            DesignSystem.primaryContainer,
                                        foregroundColor:
                                            DesignSystem.onPrimaryContainer,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        elevation: 0,
                                        shadowColor: DesignSystem
                                            .primaryContainer
                                            .withValues(alpha: 0.20),
                                      ),
                                      onPressed: _login,
                                      child: Text(
                                        'SIGN IN',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 11 * 0.25, // 0.25em
                                          color:
                                              DesignSystem.onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
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

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 1),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 11 * 0.05, // 0.05em
          color: DesignSystem.onSurfaceVariant,
        ),
      ),
    );
  }
}
