package com.jamydevph.focapflutter

import android.accessibilityservice.AccessibilityService
import android.content.pm.ApplicationInfo
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class FocapAccessibilityService : AccessibilityService() {

    private var foregroundPackage: String? = null

    private val logsForegroundApps: Boolean by lazy {
        applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE != 0
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        foregroundPackage = null
        if (logsForegroundApps) Log.d(LOG_TAG, "Service connected")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        val packageName = event.packageName?.toString() ?: return
        if (packageName == foregroundPackage) return
        foregroundPackage = packageName
        if (logsForegroundApps) Log.d(LOG_TAG, "Foreground app: $packageName")
    }

    override fun onInterrupt() = Unit

    private companion object {
        const val LOG_TAG = "FocapAccessibility"
    }
}
