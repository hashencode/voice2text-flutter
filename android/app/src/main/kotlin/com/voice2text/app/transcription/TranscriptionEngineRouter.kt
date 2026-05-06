package com.voice2text.app.transcription

import android.content.Context

class TranscriptionEngineRouter(
    context: Context,
    private val stub: TranscriptionEngine = StubSherpaTranscriptionEngine(),
    private val real: TranscriptionEngine = RealSherpaTranscriptionEngine(context),
) {
    fun resolve(mode: String): TranscriptionEngine {
        return when (mode) {
            "stub" -> stub
            "real" -> real
            "auto" -> real
            else -> stub
        }
    }
}
