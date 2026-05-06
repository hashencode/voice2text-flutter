package com.voice2text.app.transcription

data class TranscriptionRequest(
    val recordingPath: String,
    val durationMs: Int,
    val modelId: String,
    val sampleRateHz: Int,
    val enablePunctuation: Boolean,
    val enableDenoise: Boolean,
    val engineMode: String,
)

interface TranscriptionEngine {
    fun transcribe(request: TranscriptionRequest): String
}
