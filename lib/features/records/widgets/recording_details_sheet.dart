import 'package:flutter/material.dart';

import '../../shared/utils/formatters.dart';
import '../../transcription/model/transcription_job_entity.dart';

Future<void> showRecordingDetailsSheet({
  required BuildContext context,
  required String title,
  required String path,
  required int durationMs,
  required int createdAtMs,
  required TranscriptionJobEntity? latestJob,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (BuildContext context) {
      final ThemeData theme = Theme.of(context);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Text('时长: ${formatDurationMs(durationMs)}'),
              const SizedBox(height: 8),
              Text(
                '创建时间: ${DateTime.fromMillisecondsSinceEpoch(createdAtMs)}',
              ),
              const SizedBox(height: 8),
              Text('路径: $path'),
              if (latestJob != null) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  '最近转写: ${_statusLabel(latestJob.status)}',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  latestJob.resultText?.trim().isNotEmpty == true
                      ? latestJob.resultText!
                      : (latestJob.errorMessage?.trim().isNotEmpty == true
                            ? latestJob.errorMessage!
                            : latestJob.recordingPath),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

String _statusLabel(String status) {
  switch (status) {
    case 'pending':
      return '待处理';
    case 'processing':
      return '处理中';
    case 'completed':
      return '已完成';
    case 'failed':
      return '失败';
    default:
      return status;
  }
}
