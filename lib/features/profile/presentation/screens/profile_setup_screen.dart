import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  Uint8List? _photo;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => _photo = bytes);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the photo library.')),
        );
      }
    }
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: persist profile once the backend contract is available.
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                onPressed: () => context.go(AppRoutes.login),
                icon: const Icon(Icons.chevron_left),
              ),
              Text('Tell us about yourself', style: textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'This helps us provide a better experience',
                style: textTheme.bodySmall,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        GestureDetector(
                          key: const Key('add_photo'),
                          onTap: _pickPhoto,
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                    key: const Key('profile_avatar'),
                                    radius: 32,
                                    backgroundColor: AppColors.border,
                                    backgroundImage: _photo == null
                                        ? null
                                        : MemoryImage(_photo!),
                                    child: _photo == null
                                        ? const Icon(
                                            Icons.person,
                                            size: 32,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    right: -2,
                                    bottom: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.photo_camera_outlined,
                                        size: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                _photo == null ? 'Add Photo' : 'Change Photo',
                                style: textTheme.bodySmall,
                              ),
                              Text(
                                '(Optional)',
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppTextField(
                          fieldKey: const Key('name_field'),
                          controller: _name,
                          hint: 'Your Name',
                          icon: Icons.person_outline,
                          validator: Validators.name,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          fieldKey: const Key('email_field'),
                          controller: _email,
                          hint: 'Email Address (Optional)',
                          icon: Icons.mail_outline,
                          validator: Validators.optionalEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PrimaryButton(label: 'Continue', onPressed: _continue),
            ],
          ),
        ),
      ),
    );
  }
}
