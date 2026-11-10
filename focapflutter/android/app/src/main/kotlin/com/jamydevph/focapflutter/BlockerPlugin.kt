package com.jamydevph.focapflutter

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

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

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
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
        appContext = null
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
            "getInstalledApps" -> result.success(stubInstalledApps())
            "isAccessibilityEnabled" -> result.success(stubBool(false))
            "openAccessibilitySettings" -> result.success(stubNoOp())
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
        sink.success(accessibilityEvent(stubBool(false)))
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    private fun accessibilityEvent(enabled: Boolean): Map<String, Any> =
        mapOf("type" to ACCESSIBILITY_CHANGED, "value" to enabled)

    private fun stubBool(value: Boolean): Boolean = value

    private fun stubNoOp(): Any? = null

    private fun stubInstalledApps(): List<Map<String, Any>> = listOf(
        mapOf(
            "packageName" to "com.jamydevph.stub",
            "label" to "Stub app",
            "icon" to ByteArray(0),
        ),
    )

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
    }
}
