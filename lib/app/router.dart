import 'package:flutter/widgets.dart';

import '../features/home/home_page.dart';
import '../features/recording/recording_page.dart';
import '../features/records/records_page.dart';
import '../features/settings/settings_page.dart';
import '../features/transcription/transcription_page.dart';
import '../features/ui_showcase/pages/avoid_keyboard_component_page.dart';
import '../features/ui_showcase/pages/badge_component_page.dart';
import '../features/ui_showcase/pages/bna_ui_library_page.dart';
import '../features/ui_showcase/pages/input_otp_component_page.dart';
import '../features/ui_showcase/pages/separator_component_page.dart';
import '../features/ui_showcase/pages/tabs_component_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String recording = '/recording';
  static const String transcription = '/transcription';
  static const String records = '/records';
  static const String settings = '/settings';
  static const String uiShowcase = '/ui-showcase';
  static const String uiShowcaseAvoidKeyboard = '/ui-showcase/avoid-keyboard';
  static const String uiShowcaseBadge = '/ui-showcase/badge';
  static const String uiShowcaseInputOtp = '/ui-showcase/input-otp';
  static const String uiShowcaseSeparator = '/ui-showcase/separator';
  static const String uiShowcaseTabs = '/ui-showcase/tabs';

  static Map<String, WidgetBuilder> get map => <String, WidgetBuilder>{
    home: (_) => const HomePage(),
    recording: (_) => const RecordingPage(),
    transcription: (_) => const TranscriptionPage(),
    records: (_) => const RecordsPage(),
    settings: (_) => const SettingsPage(),
    uiShowcase: (_) => const BnaUiLibraryPage(),
    uiShowcaseAvoidKeyboard: (_) => const BnaAvoidKeyboardComponentPage(),
    uiShowcaseBadge: (_) => const BnaBadgeComponentPage(),
    uiShowcaseInputOtp: (_) => const BnaInputOtpComponentPage(),
    uiShowcaseSeparator: (_) => const BnaSeparatorComponentPage(),
    uiShowcaseTabs: (_) => const BnaTabsComponentPage(),
  };
}
