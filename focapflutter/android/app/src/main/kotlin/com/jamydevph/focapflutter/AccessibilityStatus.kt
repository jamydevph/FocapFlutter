package com.jamydevph.focapflutter

import android.content.ComponentName
import android.content.Context
import android.database.ContentObserver
import android.os.Handler
import android.os.Looper
import android.provider.Settings

class AccessibilityStatus(context: Context) {

    private val resolver = context.contentResolver
    private val serviceComponent = ComponentName(context, FocapAccessibilityService::class.java)
    private var observer: ContentObserver? = null
    private var lastReported: Boolean? = null

    fun isEnabled(): Boolean {
        val accessibilityOn =
            Settings.Secure.getInt(resolver, Settings.Secure.ACCESSIBILITY_ENABLED, 0) == 1
        if (!accessibilityOn) return false
        val enabledServices =
            Settings.Secure.getString(resolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES)
                ?: return false
        return enabledServices
            .split(SERVICE_SEPARATOR)
            .any { ComponentName.unflattenFromString(it.trim()) == serviceComponent }
    }

    fun watch(onChange: (Boolean) -> Unit) {
        stopWatching()
        lastReported = isEnabled()
        val settingsObserver = object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean) {
                val enabled = isEnabled()
                if (enabled == lastReported) return
                lastReported = enabled
                onChange(enabled)
            }
        }
        WATCHED_SETTINGS.forEach { name ->
            resolver.registerContentObserver(Settings.Secure.getUriFor(name), false, settingsObserver)
        }
        observer = settingsObserver
    }

    fun stopWatching() {
        observer?.let(resolver::unregisterContentObserver)
        observer = null
        lastReported = null
    }

    private companion object {
        const val SERVICE_SEPARATOR = ':'
        val WATCHED_SETTINGS = listOf(
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES,
            Settings.Secure.ACCESSIBILITY_ENABLED,
        )
    }
}
