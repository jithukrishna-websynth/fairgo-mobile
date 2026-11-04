import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLanguage {
  const AppLanguage(this.code, this.nativeName, this.englishName);

  final String code;
  final String nativeName;
  final String englishName;
}

const supportedLanguages = [
  AppLanguage('en', 'English', 'English'),
  AppLanguage('hi', 'हिन्दी', 'Hindi'),
  AppLanguage('bn', 'বাংলা', 'Bengali'),
  AppLanguage('te', 'తెలుగు', 'Telugu'),
  AppLanguage('ta', 'தமிழ்', 'Tamil'),
  AppLanguage('mr', 'मराठी', 'Marathi'),
];

class SelectedLanguage extends Notifier<String> {
  @override
  String build() => 'en';

  void select(String code) => state = code;
}

/// Selection is in-memory only; translations are not implemented yet.
final selectedLanguageProvider = NotifierProvider<SelectedLanguage, String>(
  SelectedLanguage.new,
);
