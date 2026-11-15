package com.jamydevph.focapflutter

import android.accessibilityservice.AccessibilityService
import android.content.ComponentName
import android.content.pm.ApplicationInfo
import android.provider.Settings
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class FocapAccessibilityService : AccessibilityService() {

    private val sessionStore by lazy { SessionStore(this) }
    private var foregroundPackage: String? = null

    private val isDebuggable: Boolean by lazy {
        applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE != 0
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        foregroundPackage = null
        if (isDebuggable) {
            val session = sessionStore.active()
            Log.d(LOG_TAG, "Service connected; active session: ${session?.sessionId ?: "none"}")
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        val packageName = event.packageName?.toString() ?: return
        if (isSystemOverlay(packageName)) return
        logForegroundChange(packageName)
        blockIfNeeded(packageName)
    }

    override fun onInterrupt() = Unit

    private fun isSystemOverlay(packageName: String): Boolean =
        packageName == SYSTEM_UI_PACKAGE || packageName == currentKeyboardPackage()

    private fun currentKeyboardPackage(): String? = runCatching {
        Settings.Secure.getString(contentResolver, Settings.Secure.DEFAULT_INPUT_METHOD)
            ?.let(ComponentName::unflattenFromString)
            ?.packageName
    }.getOrNull()

    private fun logForegroundChange(packageName: String) {
        if (packageName == foregroundPackage) return
        foregroundPackage = packageName
        if (isDebuggable) Log.d(LOG_TAG, "Foreground app: $packageName")
    }

    private fun blockIfNeeded(packageName: String) {
        val session = sessionStore.active() ?: return
        if (packageName !in session.blockedPackages) return
        if (packageName in InstalledApps.neverBlockablePackages(this)) return
        runCatching { startActivity(BlockActivity.intent(this, packageName)) }
            .onSuccess { if (isDebuggable) Log.d(LOG_TAG, "Block screen shown for $packageName") }
            .onFailure { Log.w(LOG_TAG, "Block screen failed to open", it) }
    }

    private companion object {
        const val LOG_TAG = "FocapAccessibility"
        const val SYSTEM_UI_PACKAGE = "com.android.systemui"
    }
}
