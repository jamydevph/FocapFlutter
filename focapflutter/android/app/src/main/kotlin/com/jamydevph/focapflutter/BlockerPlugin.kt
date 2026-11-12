package com.jamydevph.focapflutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class BlockerPlugin :
    FlutterPlugin,
    ActivityAware,
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler {

    private var methods: MethodChannel? = null
    private var events: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private var appContext: Context? = null
    private var activity: Activity? = null
    private var stubSession: Map<String, Any>? = null
    private var installedApps: InstalledApps? = null
    private var accessibilityStatus: AccessibilityStatus? = null
    private var background: ExecutorService? = null
    private val mainThread = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        installedApps = InstalledApps(binding.applicationContext)
        accessibilityStatus = AccessibilityStatus(binding.applicationContext)
        background = Executors.newSingleThreadExecutor()
        methods = MethodChannel(binding.binaryMessenger, METHOD_CHANNEL).also {
            it.setMethodCallHandler(this)
        }
        events = EventChannel(binding.binaryMessenger, EVENT_CHANNEL).also {
            it.setStreamHandler(this)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methods?.setMethodCallHandler(null)
        events?.setStreamHandler(null)
        methods = null
        events = null
        eventSink = null
        accessibilityStatus?.stopWatching()
        accessibilityStatus = null
        appContext = null
        installedApps = null
        background?.shutdownNow()
        background = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getInstalledApps" -> sendInstalledApps(result)
            "isAccessibilityEnabled" -> sendAccessibilityEnabled(result)
            "openAccessibilitySettings" -> openAccessibilitySettings(result)
            "startSession" -> startStubSession(call, result)
            "endSession" -> {
                stubSession = null
                result.success(null)
            }
            "getActiveSession" -> result.success(activeStubSession())
            "requestNotificationPermission" -> result.success(stubBool(false))
            "canScheduleExactAlarms" -> result.success(stubBool(true))
            "openExactAlarmSettings" -> result.success(stubNoOp())
            "areNotificationsEnabled" -> result.success(stubBool(false))
            "openNotificationSettings" -> result.success(stubNoOp())
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
        accessibilityStatus?.watch { enabled -> eventSink?.success(accessibilityEvent(enabled)) }
    }

    override fun onCancel(arguments: Any?) {
        accessibilityStatus?.stopWatching()
        eventSink = null
    }

    private fun accessibilityEvent(enabled: Boolean): Map<String, Any> =
        mapOf("type" to ACCESSIBILITY_CHANGED, "value" to enabled)

    private fun sendAccessibilityEnabled(result: MethodChannel.Result) {
        val status = accessibilityStatus
        if (status == null) {
            result.error(NOT_ATTACHED, "isAccessibilityEnabled called before the engine attached", null)
            return
        }
        result.success(status.isEnabled())
    }

    private fun openAccessibilitySettings(result: MethodChannel.Result) {
        val context = activity ?: appContext
        if (context == null) {
            result.error(NOT_ATTACHED, "openAccessibilitySettings called before the engine attached", null)
            return
        }
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        runCatching { context.startActivity(intent) }
            .onSuccess { result.success(null) }
            .onFailure { result.error(SETTINGS_UNAVAILABLE, it.message, null) }
    }

    private fun stubBool(value: Boolean): Boolean = value

    private fun stubNoOp(): Any? = null

    private fun sendInstalledApps(result: MethodChannel.Result) {
        val apps = installedApps
        val executor = background
        if (apps == null || executor == null) {
            result.error(NOT_ATTACHED, "getInstalledApps called before the engine attached", null)
            return
        }
        executor.execute {
            val outcome = runCatching { apps.list() }
            mainThread.post {
                if (methods == null) return@post
                outcome
                    .onSuccess { result.success(it) }
                    .onFailure { result.error(INSTALLED_APPS_FAILED, it.message, null) }
            }
        }
    }

    private fun startStubSession(call: MethodCall, result: MethodChannel.Result) {
        val sessionId = call.argument<String>("sessionId")
        val endsAtMillis = call.argument<Number>("endsAtMillis")?.toLong()
        val packages = call.argument<List<String>>("packages")
        val endSoundOn = call.argument<Boolean>("endSoundOn")
        val missing = listOfNotNull(
            "sessionId".takeIf { sessionId == null },
            "endsAtMillis".takeIf { endsAtMillis == null },
            "packages".takeIf { packages == null },
            "endSoundOn".takeIf { endSoundOn == null },
        )
        if (missing.isNotEmpty()) {
            result.error(BAD_ARGUMENTS, "startSession is missing ${missing.joinToString()}", null)
            return
        }
        stubSession = mapOf(
            "sessionId" to sessionId!!,
            "endsAtMillis" to endsAtMillis!!,
            "packages" to packages!!,
        )
        result.success(true)
    }

    private fun activeStubSession(): Map<String, Any>? {
        val session = stubSession ?: return null
        val endsAtMillis = session["endsAtMillis"] as Long
        return if (System.currentTimeMillis() < endsAtMillis) session else null
    }

    private companion object {
        const val METHOD_CHANNEL = "focap/blocker"
        const val EVENT_CHANNEL = "focap/blocker/events"
        const val ACCESSIBILITY_CHANGED = "accessibilityChanged"
        const val BAD_ARGUMENTS = "bad_arguments"
        const val NOT_ATTACHED = "not_attached"
        const val INSTALLED_APPS_FAILED = "installed_apps_failed"
        const val SETTINGS_UNAVAILABLE = "settings_unavailable"
    }
}
