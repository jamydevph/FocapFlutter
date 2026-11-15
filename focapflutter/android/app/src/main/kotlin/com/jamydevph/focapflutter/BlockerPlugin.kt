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
    private var sessionStore: SessionStore? = null
    private var installedApps: InstalledApps? = null
    private var accessibilityStatus: AccessibilityStatus? = null
    private var background: ExecutorService? = null
    private val mainThread = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        sessionStore = SessionStore(binding.applicationContext)
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
        sessionStore = null
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
            "startSession" -> startSession(call, result)
            "endSession" -> endSession(result)
            "getActiveSession" -> sendActiveSession(result)
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
        if (apps == null) {
            result.error(NOT_ATTACHED, "getInstalledApps called before the engine attached", null)
            return
        }
        replyFromBackground(result, "getInstalledApps", INSTALLED_APPS_FAILED) { apps.list() }
    }

    private fun startSession(call: MethodCall, result: MethodChannel.Result) {
        val store = sessionStore
        val context = appContext
        if (store == null || context == null) {
            result.error(NOT_ATTACHED, "startSession called before the engine attached", null)
            return
        }
        val sessionId = call.argument<Any>("sessionId") as? String
        val endsAtMillis = (call.argument<Any>("endsAtMillis") as? Number)?.toLong()
            ?.takeIf { it > System.currentTimeMillis() }
        val packages = (call.argument<Any>("packages") as? List<*>)
            ?.takeIf { list -> list.all { it is String } }
            ?.filterIsInstance<String>()
        val endSoundOn = call.argument<Any>("endSoundOn") as? Boolean
        val themeMode = BlockThemeMode.fromChannelValue(call.argument<Any>("themeMode") as? String)
        if (sessionId == null || endsAtMillis == null || packages == null || endSoundOn == null ||
            themeMode == null
        ) {
            val invalid = listOfNotNull(
                "sessionId".takeIf { sessionId == null },
                "endsAtMillis".takeIf { endsAtMillis == null },
                "packages".takeIf { packages == null },
                "endSoundOn".takeIf { endSoundOn == null },
                "themeMode".takeIf { themeMode == null },
            )
            result.error(
                BAD_ARGUMENTS,
                "startSession is missing or has invalid ${invalid.joinToString()}",
                null,
            )
            return
        }
        replyFromBackground(result, "startSession", SESSION_STORE_FAILED) {
            store.save(
                ActiveSession(
                    sessionId = sessionId,
                    endsAtMillis = endsAtMillis,
                    blockedPackages = packages.toSet() - InstalledApps.neverBlockablePackages(context),
                    endSoundOn = endSoundOn,
                    themeMode = themeMode,
                ),
            )
        }
    }

    private fun endSession(result: MethodChannel.Result) {
        val store = sessionStore
        if (store == null) {
            result.error(NOT_ATTACHED, "endSession called before the engine attached", null)
            return
        }
        replyFromBackground(result, "endSession", SESSION_STORE_FAILED) {
            check(store.clear()) { "The session record could not be cleared" }
            null
        }
    }

    private fun sendActiveSession(result: MethodChannel.Result) {
        val store = sessionStore
        if (store == null) {
            result.error(NOT_ATTACHED, "getActiveSession called before the engine attached", null)
            return
        }
        replyFromBackground(result, "getActiveSession", SESSION_STORE_FAILED) {
            store.active()?.let {
                mapOf(
                    "sessionId" to it.sessionId,
                    "endsAtMillis" to it.endsAtMillis,
                    "packages" to it.blockedPackages.sorted(),
                )
            }
        }
    }

    private fun replyFromBackground(
        result: MethodChannel.Result,
        method: String,
        failureCode: String,
        work: () -> Any?,
    ) {
        val executor = background
        if (executor == null) {
            result.error(NOT_ATTACHED, "$method called before the engine attached", null)
            return
        }
        executor.execute {
            val outcome = runCatching(work)
            mainThread.post {
                if (methods == null) return@post
                outcome
                    .onSuccess { result.success(it) }
                    .onFailure { result.error(failureCode, it.message, null) }
            }
        }
    }

    private companion object {
        const val METHOD_CHANNEL = "focap/blocker"
        const val EVENT_CHANNEL = "focap/blocker/events"
        const val ACCESSIBILITY_CHANGED = "accessibilityChanged"
        const val BAD_ARGUMENTS = "bad_arguments"
        const val NOT_ATTACHED = "not_attached"
        const val INSTALLED_APPS_FAILED = "installed_apps_failed"
        const val SESSION_STORE_FAILED = "session_store_failed"
        const val SETTINGS_UNAVAILABLE = "settings_unavailable"
    }
}
