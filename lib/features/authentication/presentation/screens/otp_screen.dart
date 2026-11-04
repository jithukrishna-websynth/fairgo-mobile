import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_providers.dart';

const _otpLength = 6;
const _resendSeconds = 24;

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _secondsLeft = _resendSeconds;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) t.cancel();
      setState(() => _secondsLeft--);
    });
  }

  Future<void> _resend() async {
    await ref.read(authRepositoryProvider).sendOtp(widget.phoneNumber);
    if (!mounted) return;
    _controller.clear();
    setState(() => _error = null);
    _startTimer();
  }

  Future<void> _verify() async {
    final error = Validators.otp(_controller.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final ok = await ref
          .read(authRepositoryProvider)
          .verifyOtp(widget.phoneNumber, _controller.text);
      if (!mounted) return;
      if (ok) {
        context.go(AppRoutes.profile);
      } else {
        setState(() => _error = 'Incorrect OTP. Please try again.');
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Verification failed. Try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String get _formattedTimer {
    final s = _secondsLeft.toString().padLeft(2, '0');
    return '0:$s';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final phone = widget.phoneNumber;
    final display = phone.length == 10
        ? '+91 ${phone.substring(0, 5)} ${phone.substring(5)}'
        : phone;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                onPressed: () => context.pop(),
                icon: const Icon(Icons.chevron_left),
              ),
              Text('Verify OTP', style: textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "We've sent a 6-digit OTP to $display",
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              _OtpBoxes(
                controller: _controller,
                focusNode: _focus,
                hasError: _error != null,
                onChanged: () => setState(() => _error = null),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text("Didn't receive the OTP? ", style: textTheme.bodySmall),
                  if (_secondsLeft > 0)
                    Text(
                      'Resend in $_formattedTimer',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.forest,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    GestureDetector(
                      key: const Key('resend_otp'),
                      onTap: _resend,
                      child: Text(
                        'Resend',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.forest,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Verify',
                isLoading: _loading,
                onPressed: _verify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Six display boxes driven by one invisible text field, so paste and
/// SMS autofill work without per-box focus handling.
class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: focusNode.requestFocus,
      child: Stack(
        children: [
          ListenableBuilder(
            listenable: Listenable.merge([controller, focusNode]),
            builder: (context, _) {
              final text = controller.text;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpLength, (i) {
                  final active =
                      focusNode.hasFocus &&
                      i == text.length.clamp(0, _otpLength - 1);
                  return Container(
                    width: 40,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: hasError
                            ? AppColors.error
                            : active
                            ? AppColors.forest
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      i < text.length ? text[i] : '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                key: const Key('otp_field'),
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(_otpLength),
                ],
                onChanged: (_) => onChanged(),
                showCursor: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
