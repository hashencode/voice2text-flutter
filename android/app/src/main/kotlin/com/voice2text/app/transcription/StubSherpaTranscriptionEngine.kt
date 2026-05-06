package com.voice2text.app.transcription

import java.io.File

class StubSherpaTranscriptionEngine : TranscriptionEngine {
    override fun transcribe(request: TranscriptionRequest): String {
        if (request.recordingPath.isBlank()) {
            throw IllegalArgumentException("recordingPath 不能为空")
        }

        val recordingFile = File(request.recordingPath)
        if (!recordingFile.exists()) {
            throw IllegalArgumentException("录音文件不存在: ${request.recordingPath}")
        }

        val fileName = recordingFile.name
        return "[android-stub-sherpa] mode=${request.engineMode} model=${request.modelId} file=$fileName dur=${request.durationMs}ms sr=${request.sampleRateHz} punct=${request.enablePunctuation} denoise=${request.enableDenoise}"
    }
}
