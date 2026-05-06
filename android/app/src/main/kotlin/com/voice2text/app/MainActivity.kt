package com.voice2text.app

import android.media.MediaRecorder
import android.os.Build
import android.util.Log
import com.voice2text.app.contracts.AudioContract
import com.voice2text.app.transcription.TranscriptionRequest
import com.voice2text.app.transcription.TranscriptionEngineRouter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.UUID

class MainActivity : FlutterActivity() {
    private val tag = "Voice2TextNative"
    private val channelName = AudioContract.RECORDER_CHANNEL

    private var recorder: MediaRecorder? = null
    private var outputPath: String? = null

    private var isRecording = false
    private var isPaused = false
    private var startedAtMs: Long? = null
    private var accumulatedMs: Long = 0

    private val transcriptionRouter by lazy { TranscriptionEngineRouter(this) }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                when (call.method) {
                    "start" -> handleStart(result)
                    "pause" -> handlePause(result)
                    "resume" -> handleResume(result)
                    "stop" -> handleStop(result)
                    "getBuildInfo" -> handleGetBuildInfo(result)
                    "transcribe" -> handleTranscribe(call, result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun handleStart(result: MethodChannel.Result) {
        if (isRecording || recorder != null) {
            result.error("INVALID_STATE", "录音已在进行中", null)
            return
        }

        try {
            val file = createOutputFile()
            outputPath = file.absolutePath

            val mediaRecorder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                MediaRecorder(this)
            } else {
                @Suppress("DEPRECATION")
                MediaRecorder()
            }

            mediaRecorder.apply {
                setAudioSource(MediaRecorder.AudioSource.MIC)
                setOutputFormat(MediaRecorder.OutputFormat.MPEG_4) // AudioContract.CONTAINER_FORMAT = mpeg4
                setAudioEncoder(MediaRecorder.AudioEncoder.AAC) // AudioContract.CODEC = aac
                setAudioSamplingRate(AudioContract.SAMPLE_RATE_HZ)
                setAudioEncodingBitRate(AudioContract.BIT_RATE)
                setOutputFile(file.absolutePath)
                prepare()
                start()
            }

            recorder = mediaRecorder
            isRecording = true
            isPaused = false
            startedAtMs = System.currentTimeMillis()
            accumulatedMs = 0

            result.success(null)
        } catch (e: Exception) {
            cleanupRecorder()
            result.error("START_FAILED", e.message ?: "启动录音失败", null)
        }
    }

    private fun handlePause(result: MethodChannel.Result) {
        if (!isRecording || isPaused || recorder == null) {
            result.error("INVALID_STATE", "当前不在可暂停的录音状态", null)
            return
        }

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            result.error("UNSUPPORTED", "当前系统版本不支持暂停录音", null)
            return
        }

        try {
            recorder?.pause()
            val now = System.currentTimeMillis()
            accumulatedMs += now - (startedAtMs ?: now)
            startedAtMs = null
            isPaused = true
            result.success(null)
        } catch (e: Exception) {
            result.error("PAUSE_FAILED", e.message ?: "暂停录音失败", null)
        }
    }

    private fun handleResume(result: MethodChannel.Result) {
        if (!isRecording || !isPaused || recorder == null) {
            result.error("INVALID_STATE", "当前不在可继续的录音状态", null)
            return
        }

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            result.error("UNSUPPORTED", "当前系统版本不支持继续录音", null)
            return
        }

        try {
            recorder?.resume()
            isPaused = false
            startedAtMs = System.currentTimeMillis()
            result.success(null)
        } catch (e: Exception) {
            result.error("RESUME_FAILED", e.message ?: "继续录音失败", null)
        }
    }

    private fun handleStop(result: MethodChannel.Result) {
        if (!isRecording || recorder == null) {
            result.error("INVALID_STATE", "当前没有正在进行的录音", null)
            return
        }

        try {
            val now = System.currentTimeMillis()
            if (!isPaused && startedAtMs != null) {
                accumulatedMs += now - (startedAtMs ?: now)
            }

            recorder?.stop()
            recorder?.release()

            val path = outputPath ?: ""
            val payload = hashMapOf<String, Any>(
                "path" to path,
                "durationMs" to accumulatedMs.toInt(),
            )

            resetStateAfterStop()
            result.success(payload)
        } catch (e: Exception) {
            cleanupRecorder()
            result.error("STOP_FAILED", e.message ?: "停止录音失败", null)
        }
    }

    private fun handleTranscribe(call: MethodCall, result: MethodChannel.Result) {
        val recordingPath = call.argument<String>("recordingPath") ?: ""
        val durationMs = call.argument<Int>("durationMs") ?: 0
        val modelId = call.argument<String>("modelId") ?: "paraformer-zh"
        val sampleRateHz = call.argument<Int>("sampleRateHz") ?: 16000
        val enablePunctuation = call.argument<Boolean>("enablePunctuation") ?: true
        val enableDenoise = call.argument<Boolean>("enableDenoise") ?: true
        val engineMode = call.argument<String>("engineMode") ?: "auto"
        val started = System.currentTimeMillis()

        try {
            val request = TranscriptionRequest(
                recordingPath = recordingPath,
                durationMs = durationMs,
                modelId = modelId,
                sampleRateHz = sampleRateHz,
                enablePunctuation = enablePunctuation,
                enableDenoise = enableDenoise,
                engineMode = engineMode,
            )
            val text = transcriptionRouter.resolve(engineMode).transcribe(request)
            Log.i(
                tag,
                "transcribe ok mode=$engineMode model=$modelId durationMs=$durationMs costMs=${System.currentTimeMillis() - started}",
            )
            result.success(text)
        } catch (e: IllegalArgumentException) {
            Log.e(tag, "transcribe invalid_arg: ${e.message}", e)
            result.error("INVALID_ARG", e.message ?: "参数错误", null)
        } catch (e: Exception) {
            Log.e(tag, "transcribe failed mode=$engineMode model=$modelId path=$recordingPath", e)
            result.error("TRANSCRIBE_FAILED", e.message ?: "转写失败", null)
        }
    }

    private fun handleGetBuildInfo(result: MethodChannel.Result) {
        try {
            val pkg = packageManager.getPackageInfo(packageName, 0)
            val payload = hashMapOf<String, Any>(
                "packageName" to packageName,
                "versionName" to (pkg.versionName ?: ""),
                "lastUpdateTimeMs" to pkg.lastUpdateTime,
            )
            result.success(payload)
        } catch (e: Exception) {
            result.error("BUILD_INFO_FAILED", e.message ?: "读取构建信息失败", null)
        }
    }

    private fun createOutputFile(): File {
        val root = File(filesDir, AudioContract.RECORDING_DIR_NAME)
        if (!root.exists()) {
            root.mkdirs()
        }
        val name = "record-${System.currentTimeMillis()}-${UUID.randomUUID()}.${AudioContract.RECORDING_EXTENSION}"
        return File(root, name)
    }

    private fun resetStateAfterStop() {
        recorder = null
        outputPath = null
        isRecording = false
        isPaused = false
        startedAtMs = null
        accumulatedMs = 0
    }

    private fun cleanupRecorder() {
        try {
            recorder?.release()
        } catch (_: Exception) {
        }
        recorder = null
        outputPath = null
        isRecording = false
        isPaused = false
        startedAtMs = null
        accumulatedMs = 0
    }
}
