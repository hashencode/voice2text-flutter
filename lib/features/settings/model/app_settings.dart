class AppSettings {
  AppSettings({
    required this.modelId,
    required this.autoTranscribe,
  });

  final String modelId;
  final bool autoTranscribe;

  static AppSettings defaults() {
    return AppSettings(
      modelId: 'paraformer-zh',
      autoTranscribe: true,
    );
  }
}
