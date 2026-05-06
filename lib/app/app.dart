import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class Voice2TextApp extends StatelessWidget {
  const Voice2TextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice2Text',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.recording,
      routes: AppRoutes.map,
    );
  }
}
