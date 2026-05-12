import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path/path.dart' as p;

import '../records/model/recording_entity.dart';
import '../records/repository/recordings_repository.dart';
import '../shared/utils/formatters.dart';

const Color _homeBackground = Color(0xFFF5F5F5);
const Color _homeSurface = Colors.white;
const Color _homeSurfaceActive = Color(0x0F000000);
const Color _homeText = Color(0xE0000000);
const Color _homeMutedText = Color(0x8C000000);
const Color _homeDivider = Color(0xFFF0F0F0);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RecordingsRepository _repository = RecordingsRepository();

  List<_RecordingPreview> _items = const <_RecordingPreview>[];
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

    List<RecordingEntity> records = const <RecordingEntity>[];
    try {
      records = await _repository.listRecent();
    } catch (_) {
      records = const <RecordingEntity>[];
    }
    if (!mounted) return;

    setState(() {
      _items = records.isEmpty
          ? const <_RecordingPreview>[
              _RecordingPreview(
                title: '导入音频-2605071125',
                duration: '未知时长',
                date: '2026-05-07 11:25',
              ),
            ]
          : records.map(_RecordingPreview.fromEntity).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: _homeBackground,
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints _) {
              final double fabBottom =
                  MediaQuery.of(context).padding.bottom + 18;

              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(height: 56, child: _HomeHeader()),
                      ),
                      const _GroupTabs(),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: _homeSurface,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          child: _HomeList(items: _items, loading: _loading),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 16,
                    bottom: fabBottom,
                    child: _RecordFab(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/recording');
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            '音频',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w400,
              color: _homeText,
              letterSpacing: 0,
              height: 1,
            ),
          ),
        ),
        _HeaderIconButton(icon: LucideIcons.search300),
        SizedBox(width: 32),
        _HeaderIconButton(icon: LucideIcons.fileInput300),
        SizedBox(width: 32),
        _HeaderIconButton(icon: LucideIcons.sun300),
      ],
    );
  }
}

class _GroupTabs extends StatelessWidget {
  const _GroupTabs();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 10, 0, 10),
      child: SizedBox(
        height: 36,
        child: Row(
          children: <Widget>[
            _IconTab(),
            SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _TextTab(label: '全部音频', active: true),
                    SizedBox(width: 8),
                    _TextTab(label: '会议音频'),
                    SizedBox(width: 8),
                    _TextTab(label: '最近删除'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeList extends StatelessWidget {
  const _HomeList({required this.items, required this.loading});

  final List<_RecordingPreview> items;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 116),
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) => Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: _homeDivider,
      ),
      itemBuilder: (BuildContext context, int index) {
        final _RecordingPreview item = items[index];
        return SizedBox(
          height: 96,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            if (item.favorite) ...<Widget>[
                              const Icon(
                                Icons.favorite,
                                size: 17,
                                color: Color(0xFFEF4444),
                              ),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _homeText,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  height: 1.52,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: <Widget>[
                            _MetaChip(
                              icon: Icons.schedule_rounded,
                              label: item.duration,
                            ),
                            _MetaChip(
                              icon: Icons.calendar_today_outlined,
                              label: item.date,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: Icon(
                      Icons.more_horiz_rounded,
                      size: 18,
                      color: _homeText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: _homeMutedText),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: _homeMutedText,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.08,
          ),
        ),
      ],
    );
  }
}

class _TextTab extends StatelessWidget {
  const _TextTab({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: active ? _homeSurfaceActive : _homeSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: _homeText,
          fontSize: 15,
          fontWeight: active ? FontWeight.w500 : FontWeight.w400,
          height: 1.2,
        ),
      ),
    );
  }
}

class _IconTab extends StatelessWidget {
  const _IconTab();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _homeSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Icon(LucideIcons.library300, size: 18, color: _homeText),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Icon(icon, size: 24, color: _homeText),
    );
  }
}

class _RecordFab extends StatelessWidget {
  const _RecordFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFF1E6BFF),
            borderRadius: BorderRadius.all(Radius.circular(24)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0x1F1E6BFF),
                blurRadius: 14,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(LucideIcons.mic300, size: 32, color: Colors.white),
        ),
      ),
    );
  }
}

class _RecordingPreview {
  const _RecordingPreview({
    required this.title,
    required this.duration,
    required this.date,
    this.favorite = false,
  });

  factory _RecordingPreview.fromEntity(RecordingEntity entity) {
    return _RecordingPreview(
      title: _titleFromPath(entity.filePath, entity.id),
      duration: entity.durationMs > 0
          ? formatDurationMs(entity.durationMs)
          : '未知时长',
      date: _formatDate(entity.createdAtMs),
    );
  }

  final String title;
  final String duration;
  final String date;
  final bool favorite;
}

String _titleFromPath(String filePath, int id) {
  final String filename = p.basenameWithoutExtension(filePath).trim();
  if (filename.isNotEmpty) {
    return filename;
  }
  return '录音-$id';
}

String _formatDate(int createdAtMs) {
  final DateTime time = DateTime.fromMillisecondsSinceEpoch(createdAtMs);
  final String year = time.year.toString().padLeft(4, '0');
  final String month = time.month.toString().padLeft(2, '0');
  final String day = time.day.toString().padLeft(2, '0');
  final String hour = time.hour.toString().padLeft(2, '0');
  final String minute = time.minute.toString().padLeft(2, '0');
  return '$year-$month-$day $hour:$minute';
}
