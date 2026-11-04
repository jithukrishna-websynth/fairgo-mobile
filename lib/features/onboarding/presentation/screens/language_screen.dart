import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../language_provider.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedLanguageProvider);
    final q = _query.trim().toLowerCase();
    final languages = supportedLanguages
        .where(
          (l) =>
              l.englishName.toLowerCase().contains(q) ||
              l.nativeName.toLowerCase().contains(q),
        )
        .toList();
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
                onPressed: () => context.go(AppRoutes.welcome),
                icon: const Icon(Icons.chevron_left),
              ),
              Text('Select Your Language', style: textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Choose your preferred language to continue',
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search language',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: AppColors.fieldFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: languages.isEmpty
                    ? const Center(child: Text('No languages found'))
                    : ListView.separated(
                        itemCount: languages.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (_, i) {
                          final l = languages[i];
                          return _LanguageTile(
                            language: l,
                            isSelected: l.code == selected,
                            onTap: () => ref
                                .read(selectedLanguageProvider.notifier)
                                .select(l.code),
                          );
                        },
                      ),
              ),
              PrimaryButton(
                label: 'Continue',
                onPressed: () => context.go(AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.limeTint : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        side: BorderSide(color: isSelected ? AppColors.lime : AppColors.border),
      ),
      child: InkWell(
        key: Key('language_${language.code}'),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.nativeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.forest,
                      ),
                    ),
                    Text(
                      language.englishName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.forest : AppColors.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
