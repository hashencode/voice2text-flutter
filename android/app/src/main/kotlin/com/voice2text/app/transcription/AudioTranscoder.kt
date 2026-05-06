package com.voice2text.app.transcription

import android.media.MediaCodec
import android.media.MediaExtractor
import android.media.MediaFormat
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

internal interface TranscodePort {
    fun ensureWav16kMono(input: File, outputDir: File): File
}

internal class FfmpegAudioTranscoder : TranscodePort {
    override fun ensureWav16kMono(input: File, outputDir: File): File {
        throw TranscodeException("FFmpeg 转码器尚未接入，请先使用 NativeAudioTranscoder")
    }
}

internal class NativeAudioTranscoder : TranscodePort {
    override fun ensureWav16kMono(input: File, outputDir: File): File {
        if (input.extension.equals("wav", ignoreCase = true)) {
            return input
        }
        if (!input.extension.equals("m4a", ignoreCase = true)) {
            throw TranscodeException("暂不支持该音频格式: ${input.extension}")
        }
        if (!outputDir.exists()) {
            outputDir.mkdirs()
        }
        val output = File(
            outputDir,
            "${input.nameWithoutExtension}-${System.currentTimeMillis()}-16k-mono.wav",
        )
        transcodeM4aToWav16kMono(input, output)
        return output
    }

    private fun transcodeM4aToWav16kMono(input: File, output: File) {
        val extractor = MediaExtractor()
        var codec: MediaCodec? = null
        try {
            extractor.setDataSource(input.absolutePath)
            val trackIndex = selectAudioTrack(extractor)
            if (trackIndex < 0) {
                throw IllegalStateException("未找到音频轨道")
            }
            extractor.selectTrack(trackIndex)
            val trackFormat = extractor.getTrackFormat(trackIndex)
            val mime = trackFormat.getString(MediaFormat.KEY_MIME)
                ?: throw IllegalStateException("音频 MIME 为空")
            codec = MediaCodec.createDecoderByType(mime)
            codec.configure(trackFormat, null, null, 0)
            codec.start()

            val inputBuffers = codec.inputBuffers
            val bufferInfo = MediaCodec.BufferInfo()
            val pcm = ByteArrayOutputStream()
            var sawInputEos = false
            var sawOutputEos = false

            while (!sawOutputEos) {
                if (!sawInputEos) {
                    val inIndex = codec.dequeueInputBuffer(10_000)
                    if (inIndex >= 0) {
                        val inputBuffer = inputBuffers[inIndex]
                        inputBuffer.clear()
                        val sampleSize = extractor.readSampleData(inputBuffer, 0)
                        if (sampleSize < 0) {
                            codec.queueInputBuffer(
                                inIndex,
                                0,
                                0,
                                0,
                                MediaCodec.BUFFER_FLAG_END_OF_STREAM,
                            )
                            sawInputEos = true
                        } else {
                            codec.queueInputBuffer(
                                inIndex,
                                0,
                                sampleSize,
                                extractor.sampleTime,
                                0,
                            )
                            extractor.advance()
                        }
                    }
                }

                val outIndex = codec.dequeueOutputBuffer(bufferInfo, 10_000)
                when {
                    outIndex >= 0 -> {
                        val outBuffer = codec.getOutputBuffer(outIndex)
                        if (outBuffer != null && bufferInfo.size > 0) {
                            val chunk = ByteArray(bufferInfo.size)
                            outBuffer.position(bufferInfo.offset)
                            outBuffer.limit(bufferInfo.offset + bufferInfo.size)
                            outBuffer.get(chunk)
                            pcm.write(chunk)
                        }
                        codec.releaseOutputBuffer(outIndex, false)
                        if ((bufferInfo.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM) != 0) {
                            sawOutputEos = true
                        }
                    }
                    outIndex == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED -> {
                        // Use final output format after decode for sample/channels.
                    }
                }
            }

            val outFormat = codec.outputFormat
            val srcSampleRate = outFormat.getInteger(MediaFormat.KEY_SAMPLE_RATE)
            val srcChannelCount = outFormat.getInteger(MediaFormat.KEY_CHANNEL_COUNT)
            val pcmEncoding = if (outFormat.containsKey(MediaFormat.KEY_PCM_ENCODING)) {
                outFormat.getInteger(MediaFormat.KEY_PCM_ENCODING)
            } else {
                2 // ENCODING_PCM_16BIT
            }
            val decodedBytes = pcm.toByteArray()
            val mono16k = convertToMono16k(decodedBytes, srcSampleRate, srcChannelCount, pcmEncoding)
            writeWav16kMono(output, mono16k)
        } finally {
            try {
                codec?.stop()
            } catch (_: Exception) {
            }
            try {
                codec?.release()
            } catch (_: Exception) {
            }
            try {
                extractor.release()
            } catch (_: Exception) {
            }
        }
    }

    private fun selectAudioTrack(extractor: MediaExtractor): Int {
        for (i in 0 until extractor.trackCount) {
            val format = extractor.getTrackFormat(i)
            val mime = format.getString(MediaFormat.KEY_MIME) ?: continue
            if (mime.startsWith("audio/")) return i
        }
        return -1
    }

    private fun convertToMono16k(
        bytes: ByteArray,
        srcSampleRate: Int,
        srcChannelCount: Int,
        pcmEncoding: Int,
    ): ShortArray {
        val interleaved = decodePcmToInterleaved(bytes, srcChannelCount, pcmEncoding)
        val mono = downMixToMono(interleaved, srcChannelCount)
        return if (srcSampleRate == 16_000) mono else resampleLinear(mono, srcSampleRate, 16_000)
    }

    private fun decodePcmToInterleaved(
        bytes: ByteArray,
        channelCount: Int,
        pcmEncoding: Int,
    ): ShortArray {
        if (channelCount <= 0) throw TranscodeException("无效声道数: $channelCount")
        val bb = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)
        return when (pcmEncoding) {
            2 -> { // ENCODING_PCM_16BIT
                val out = ShortArray(bytes.size / 2)
                var i = 0
                while (bb.remaining() >= 2) {
                    out[i++] = bb.short
                }
                out
            }
            3 -> { // ENCODING_PCM_8BIT
                val out = ShortArray(bytes.size)
                for (i in bytes.indices) {
                    val u = bytes[i].toInt() and 0xFF
                    out[i] = ((u - 128) shl 8).toShort()
                }
                out
            }
            else -> throw TranscodeException("暂不支持 PCM 编码: $pcmEncoding")
        }
    }

    private fun downMixToMono(interleaved: ShortArray, channels: Int): ShortArray {
        if (channels == 1) return interleaved
        val frames = interleaved.size / channels
        val out = ShortArray(frames)
        var src = 0
        for (i in 0 until frames) {
            var sum = 0
            for (c in 0 until channels) {
                sum += interleaved[src++].toInt()
            }
            out[i] = (sum / channels).toShort()
        }
        return out
    }

    private fun resampleLinear(input: ShortArray, srcRate: Int, dstRate: Int): ShortArray {
        if (input.isEmpty()) return input
        val outLen = max(1, (input.size.toDouble() * dstRate / srcRate).roundToInt())
        val out = ShortArray(outLen)
        val step = srcRate.toDouble() / dstRate
        for (i in 0 until outLen) {
            val pos = i * step
            val left = min(input.lastIndex, pos.toInt())
            val right = min(input.lastIndex, left + 1)
            val frac = pos - left
            val sample = input[left] * (1.0 - frac) + input[right] * frac
            out[i] = sample.roundToInt().toShort()
        }
        return out
    }

    private fun writeWav16kMono(file: File, pcm: ShortArray) {
        val dataSize = pcm.size * 2
        val header = ByteBuffer.allocate(44).order(ByteOrder.LITTLE_ENDIAN).apply {
            put("RIFF".toByteArray())
            putInt(36 + dataSize)
            put("WAVE".toByteArray())
            put("fmt ".toByteArray())
            putInt(16)
            putShort(1) // PCM
            putShort(1) // mono
            putInt(16_000)
            putInt(16_000 * 2)
            putShort(2)
            putShort(16)
            put("data".toByteArray())
            putInt(dataSize)
        }.array()

        FileOutputStream(file).use { fos ->
            fos.write(header)
            val pcmBytes = ByteBuffer.allocate(dataSize).order(ByteOrder.LITTLE_ENDIAN)
            for (s in pcm) pcmBytes.putShort(s)
            fos.write(pcmBytes.array())
            fos.flush()
        }
    }
}

internal class TranscodeException(message: String, cause: Throwable? = null) : Exception(message, cause)
