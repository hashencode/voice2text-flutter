import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_mode_controller.dart';

class Voice2TextApp extends StatefulWidget {
  const Voice2TextApp({super.key});

  @override
  State<Voice2TextApp> createState() => _Voice2TextAppState();
}

class _Voice2TextAppState extends State<Voice2TextApp> {
  late final AppThemeModeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = AppThemeModeController()..load();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeModeScope(
      notifier: _themeController,
      child: AnimatedBuilder(
        animation: _themeController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            title: 'Voice2Text',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: _themeController.themeMode,
            initialRoute: AppRoutes.home,
            routes: AppRoutes.map,
          );
        },
      ),
    );
  }
}
