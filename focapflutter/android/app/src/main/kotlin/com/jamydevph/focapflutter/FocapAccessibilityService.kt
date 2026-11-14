package com.jamydevph.focapflutter

import android.accessibilityservice.AccessibilityService
import android.content.pm.ApplicationInfo
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class FocapAccessibilityService : AccessibilityService() {

    private var foregroundPackage: String? = null
    private var debugBlockEndsAtMillis = 0L

    private val isDebuggable: Boolean by lazy {
        applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE != 0
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        foregroundPackage = null
        if (isDebuggable) {
            debugBlockEndsAtMillis = System.currentTimeMillis() + DEBUG_BLOCK_MILLIS
            Log.d(LOG_TAG, "Service connected; blocking $DEBUG_BLOCK_PACKAGE for testing")
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        val packageName = event.packageName?.toString() ?: return
        logForegroundChange(packageName)
        blockIfNeeded(packageName)
    }

    override fun onInterrupt() = Unit

    private fun logForegroundChange(packageName: String) {
        if (packageName == foregroundPackage) return
        foregroundPackage = packageName
        if (isDebuggable) Log.d(LOG_TAG, "Foreground app: $packageName")
    }

    private fun blockIfNeeded(packageName: String) {
        if (!isDebuggable || packageName != DEBUG_BLOCK_PACKAGE) return
        if (System.currentTimeMillis() >= debugBlockEndsAtMillis) return
        runCatching { startActivity(BlockActivity.intent(this, packageName, debugBlockEndsAtMillis)) }
            .onSuccess { Log.d(LOG_TAG, "Block screen shown for $packageName") }
            .onFailure { Log.w(LOG_TAG, "Block screen failed for $packageName", it) }
    }

    private companion object {
        const val LOG_TAG = "FocapAccessibility"
        const val DEBUG_BLOCK_PACKAGE = "com.google.android.calendar"
        const val DEBUG_BLOCK_MILLIS = 25L * 60L * 1000L
    }
}
