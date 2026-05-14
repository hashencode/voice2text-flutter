import 'package:flutter/material.dart';

import '../shared/utils/formatters.dart';
import '../shared/widgets/build_info_footer.dart';
import '../shared/widgets/common_empty_state.dart';
import 'model/recording_entity.dart';
import 'repository/recordings_repository.dart';
import 'package:path/path.dart' as p;
import 'widgets/recording_details_sheet.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  final RecordingsRepository _repository = RecordingsRepository();

  List<RecordingEntity> _items = <RecordingEntity>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
    });
    final items = await _repository.listActive();
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _showItemActions(RecordingEntity item) async {
    final String? action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('查看详情'),
                onTap: () => Navigator.of(context).pop('detail'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('删除记录', style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.of(context).pop('delete'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null) return;

    if (action == 'detail') {
      _showDetails(item);
      return;
    }

    if (action == 'delete') {
      await _deleteItem(item);
    }
  }

  void _showDetails(RecordingEntity item) {
    showRecordingDetailsSheet(
      context: context,
      title: _displayTitle(item),
      path: item.filePath,
      durationMs: item.durationMs,
      createdAtMs: item.createdAtMs,
      latestJob: null,
    );
  }

  Future<void> _deleteItem(RecordingEntity item) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('删除录音记录'),
          content: const Text('会同时删除关联转写任务记录，此操作不可撤销。'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _repository.softDeleteById(item.id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已移入最近删除')),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('记录'),
        actions: <Widget>[
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
            tooltip: '刷新',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? const CommonEmptyState(
              icon: Icons.library_music_outlined,
              title: '暂无录音记录',
              description: '先回到录音页完成一次录音并保存，记录会出现在这里。',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 8),
              itemBuilder: (BuildContext context, int index) {
                final item = _items[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.mic_none)),
                    title: Text(_displayTitle(item)),
                    subtitle: Text(
                      '${formatDurationMs(item.durationMs)}  •  ${item.filePath}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      _showDetails(item);
                    },
                    onLongPress: () {
                      _showItemActions(item);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: const SafeArea(top: false, child: BuildInfoFooter()),
    );
  }

  String _displayTitle(RecordingEntity item) {
    final String? displayName = item.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }
    final String filename = p.basenameWithoutExtension(item.filePath).trim();
    if (filename.isNotEmpty) {
      return filename;
    }
    return '录音 #${item.id}';
  }
}
