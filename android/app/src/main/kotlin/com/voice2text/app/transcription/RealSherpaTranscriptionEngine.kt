package com.voice2text.app.transcription

import android.content.Context
import com.k2fsa.sherpa.onnx.FeatureConfig
import com.k2fsa.sherpa.onnx.OfflineModelConfig
import com.k2fsa.sherpa.onnx.OfflineParaformerModelConfig
import com.k2fsa.sherpa.onnx.OfflineRecognizer
import com.k2fsa.sherpa.onnx.OfflineRecognizerConfig
import com.k2fsa.sherpa.onnx.OfflineStream
import com.k2fsa.sherpa.onnx.WaveReader
import java.io.BufferedInputStream
import java.io.File
import java.io.FileOutputStream
import java.util.concurrent.TimeUnit
import java.util.zip.ZipInputStream

internal class RealSherpaTranscriptionEngine(
    private val context: Context,
    private val transcoder: TranscodePort = NativeAudioTranscoder(),
) : TranscriptionEngine {
    private val flutterAssetPrefix = "flutter_assets/"
    override fun transcribe(request: TranscriptionRequest): String {
        if (request.recordingPath.isBlank()) {
            throw IllegalArgumentException("recordingPath 不能为空")
        }

        val recordingFile = File(request.recordingPath)
        if (!recordingFile.exists()) {
            throw IllegalArgumentException("录音文件不存在: ${request.recordingPath}")
        }
        val wasInputWav = recordingFile.extension.equals("wav", ignoreCase = true)
        val transcodeDir = File(context.cacheDir, "transcoded_audio")
        cleanupTranscodeDir(transcodeDir)
        val wavFile = try {
            transcoder.ensureWav16kMono(
                input = recordingFile,
                outputDir = transcodeDir,
            )
        } catch (e: TranscodeException) {
            throw IllegalStateException("转码失败: ${e.message}", e)
        } catch (e: Exception) {
            throw IllegalStateException("转码失败: ${e.message ?: "未知错误"}", e)
        }

        val modelAssetPath = modelAssetFor(request.modelId)
        val requiredAssets = requiredAssetsForModel(modelAssetPath)
        val missing = requiredAssets.filterNot { assetExists(it) }
        if (missing.isNotEmpty()) {
            throw IllegalStateException("模型资源缺失: ${missing.joinToString(",")}")
        }
        val extractedModel = ensureModelExtracted(modelAssetPath)
        if (!extractedModel.modelFile.exists() || !extractedModel.tokensFile.exists()) {
            throw IllegalStateException("模型解压失败: onnx/tokens 文件不存在")
        }

        val recognizer = OfflineRecognizer(
            null as android.content.res.AssetManager?,
            createRecognizerConfig(
                modelFilePath = extractedModel.modelFile.absolutePath,
                tokensFilePath = extractedModel.tokensFile.absolutePath,
                sampleRateHz = request.sampleRateHz,
            ),
        )

        var stream: OfflineStream? = null
        try {
            val wave = WaveReader.Companion.readWave(wavFile.absolutePath)
            stream = recognizer.createStream()
            stream.acceptWaveform(wave.samples, wave.sampleRate)
            recognizer.decode(stream)
            val text = recognizer.getResult(stream).text.trim()
            if (text.isEmpty()) {
                throw IllegalStateException("识别失败: Sherpa 返回空文本，请检查音频有效性与模型配置")
            }
            return text
        } catch (e: IllegalStateException) {
            throw e
        } catch (e: Exception) {
            throw IllegalStateException("识别失败: ${e.message ?: "未知错误"}", e)
        } finally {
            try {
                stream?.release()
            } catch (_: Exception) {
            }
            try {
                recognizer.release()
            } catch (_: Exception) {
            }
            if (!wasInputWav && wavFile.exists()) {
                try {
                    wavFile.delete()
                } catch (_: Exception) {
                }
            }
        }
    }

    private fun createRecognizerConfig(
        modelFilePath: String,
        tokensFilePath: String,
        sampleRateHz: Int,
    ): OfflineRecognizerConfig {
        val featureConfig = FeatureConfig(
            sampleRate = sampleRateHz,
            featureDim = 80,
            dither = 0.0f,
        )
        val modelConfig = OfflineModelConfig(
            paraformer = OfflineParaformerModelConfig(model = modelFilePath),
            numThreads = 2,
            provider = "cpu",
            debug = false,
            modelType = "paraformer",
            tokens = tokensFilePath,
        )
        return OfflineRecognizerConfig(
            featConfig = featureConfig,
            modelConfig = modelConfig,
        )
    }

    private fun modelAssetFor(modelId: String): String {
        return when (modelId) {
            "paraformer-zh" -> "${flutterAssetPrefix}assets/sherpa/asr/paraformer-zh.zip"
            else -> "${flutterAssetPrefix}assets/sherpa/asr/paraformer-zh.zip"
        }
    }

    private fun requiredAssetsForModel(modelAssetPath: String): List<String> {
        return listOf(
            modelAssetPath,
        )
    }

    private fun assetExists(path: String): Boolean {
        return try {
            context.assets.open(path).use { true }
        } catch (_: Exception) {
            false
        }
    }

    private fun cleanupTranscodeDir(dir: File) {
        if (!dir.exists() || !dir.isDirectory) return
        val files = dir.listFiles()?.filter { it.isFile && it.extension.equals("wav", ignoreCase = true) } ?: return
        if (files.isEmpty()) return

        val now = System.currentTimeMillis()
        val expireMs = TimeUnit.HOURS.toMillis(24)
        files.forEach { f ->
            if (now - f.lastModified() > expireMs) {
                try {
                    f.delete()
                } catch (_: Exception) {
                }
            }
        }

        val remained = dir.listFiles()?.filter { it.isFile && it.extension.equals("wav", ignoreCase = true) } ?: return
        if (remained.size <= 20) return
        remained.sortedBy { it.lastModified() }
            .take(remained.size - 20)
            .forEach { old ->
                try {
                    old.delete()
                } catch (_: Exception) {
                }
            }
    }

    private data class ExtractedParaformerModel(
        val modelFile: File,
        val tokensFile: File,
    )

    private fun ensureModelExtracted(zipAssetPath: String): ExtractedParaformerModel {
        val modelDir = File(context.cacheDir, "sherpa_models/paraformer_zh")
        val modelFile = File(modelDir, "model.int8.onnx")
        val tokensFile = File(modelDir, "tokens.txt")
        if (modelFile.exists() && tokensFile.exists() && modelFile.length() > 0L && tokensFile.length() > 0L) {
            return ExtractedParaformerModel(modelFile, tokensFile)
        }

        if (!modelDir.exists()) modelDir.mkdirs()
        context.assets.open(zipAssetPath).use { raw ->
            ZipInputStream(BufferedInputStream(raw)).use { zis ->
                var entry = zis.nextEntry
                while (entry != null) {
                    if (!entry.isDirectory) {
                        val out = File(modelDir, entry.name.substringAfterLast('/'))
                        FileOutputStream(out).use { fos ->
                            zis.copyTo(fos)
                        }
                    }
                    zis.closeEntry()
                    entry = zis.nextEntry
                }
            }
        }
        return ExtractedParaformerModel(modelFile, tokensFile)
    }
}
