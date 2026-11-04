import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/fair_go_logo.dart';
import '../../../../core/widgets/gradient_backdrop.dart';
import '../../../../core/widgets/outlined_action_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_providers.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  bool _agreed = true;
  bool _showConsentError = false;
  bool _loading = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final valid = _formKey.currentState!.validate();
    setState(() => _showConsentError = !_agreed);
    if (!valid || !_agreed) return;

    final number = _phone.text.replaceAll(' ', '');
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).sendOtp(number);
      if (mounted) context.push('${AppRoutes.otp}?phone=$number');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not send OTP. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _socialNotReady(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider sign-in is not configured yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: GradientBackdrop(
        child: SafeArea(
          // Fills the screen on tall phones, scrolls when the keyboard is up.
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Spacer(flex: 10),
                        const FairGoLogo(width: 220),
                        const Spacer(flex: 4),
                        Text(
                          'Enter Your Mobile Number',
                          style: textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          "We'll send you an OTP to verify your number",
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          key: const Key('phone_field'),
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          validator: Validators.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            hintText: '98765 43210',
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Center(
                                widthFactor: 1,
                                child: Text('🇮🇳  +91'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _ConsentRow(
                          value: _agreed,
                          showError: _showConsentError,
                          onChanged: (v) => setState(() {
                            _agreed = v;
                            _showConsentError = !v;
                          }),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        PrimaryButton(
                          label: 'Send OTP',
                          isLoading: _loading,
                          onPressed: _sendOtp,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'Or continue with',
                                style: textTheme.bodySmall,
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        OutlinedActionButton(
                          label: 'Continue with Google',
                          icon: SvgPicture.asset('assets/icons/google_g.svg'),
                          onPressed: () => _socialNotReady('Google'),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        OutlinedActionButton(
                          label: 'Continue with Apple',
                          icon: const Icon(
                            Icons.apple,
                            size: 18,
                            color: Colors.black,
                          ),
                          onPressed: () => _socialNotReady('Apple'),
                        ),
                        const Spacer(flex: 7),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConsentRow extends StatelessWidget {
  const _ConsentRow({
    required this.value,
    required this.showError,
    required this.onChanged,
  });

  final bool value;
  final bool showError;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    const link = TextStyle(
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      color: AppColors.textPrimary,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              key: const Key('consent_checkbox'),
              value: value,
              activeColor: AppColors.forest,
              visualDensity: VisualDensity.compact,
              onChanged: (v) => onChanged(v ?? false),
            ),
            Expanded(
              child: Text.rich(
                const TextSpan(
                  children: [
                    TextSpan(text: 'I agree to the '),
                    TextSpan(text: 'Terms of Service', style: link),
                    TextSpan(text: ' and '),
                    TextSpan(text: 'Privacy Policy', style: link),
                  ],
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        if (showError)
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              'Please accept the terms to continue',
              style: TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
