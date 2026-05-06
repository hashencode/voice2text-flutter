import 'package:flutter/material.dart';

import 'model/app_settings.dart';
import 'repository/app_settings_repository.dart';
import '../shared/widgets/build_info_footer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppSettingsRepository _repository = AppSettingsRepository();

  bool _loading = true;
  String _modelId = 'paraformer-zh';
  bool _autoTranscribe = true;

  final List<String> _modelOptions = <String>[
    'paraformer-zh',
    'sherpa-streaming-zh',
    'sherpa-offline-zh',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final AppSettings settings = await _repository.load();
    if (!mounted) return;
    setState(() {
      _modelId = settings.modelId;
      _autoTranscribe = settings.autoTranscribe;
      _loading = false;
    });
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    await _repository.save(
      AppSettings(
        modelId: _modelId,
        autoTranscribe: _autoTranscribe,
      ),
    );
    if (!mounted) return;
    messenger.showSnackBar(const SnackBar(content: Text('设置已保存')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('设置')),
        body: const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: const SafeArea(
          top: false,
          child: BuildInfoFooter(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('识别模型'),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _modelId,
                    isExpanded: true,
                    items: _modelOptions
                        .map(
                          (String model) => DropdownMenuItem<String>(
                            value: model,
                            child: Text(model),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      if (value == null) return;
                      setState(() {
                        _modelId = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              title: const Text('停止录音后自动转写'),
              subtitle: const Text('关闭后只保存录音，不自动进入转写流程'),
              value: _autoTranscribe,
              onChanged: (bool value) {
                setState(() {
                  _autoTranscribe = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            child: const Text('保存设置'),
          ),
        ],
      ),
      bottomNavigationBar: const SafeArea(
        top: false,
        child: BuildInfoFooter(),
      ),
    );
  }
}
