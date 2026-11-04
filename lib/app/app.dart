import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class FairGoApp extends StatefulWidget {
  const FairGoApp({super.key});

  @override
  State<FairGoApp> createState() => _FairGoAppState();
}

class _FairGoAppState extends State<FairGoApp> {
  late final GoRouter _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FairGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
