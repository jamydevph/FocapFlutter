package com.jamydevph.focapflutter

import android.content.Context
import android.content.res.Configuration

enum class BlockThemeMode(val channelValue: String, val uiNightMode: Int?) {
    LIGHT("light", Configuration.UI_MODE_NIGHT_NO),
    DARK("dark", Configuration.UI_MODE_NIGHT_YES),
    AUTO("auto", null);

    companion object {
        fun fromChannelValue(value: String?): BlockThemeMode? =
            entries.firstOrNull { it.channelValue == value }
    }
}

data class ActiveSession(
    val sessionId: String,
    val endsAtMillis: Long,
    val blockedPackages: Set<String>,
    val endSoundOn: Boolean,
    val themeMode: BlockThemeMode,
) {
    fun isRunningAt(nowMillis: Long): Boolean = nowMillis < endsAtMillis
}

class SessionStore(context: Context) {

    private val prefs = context.getSharedPreferences(FILE_NAME, Context.MODE_PRIVATE)

    fun save(session: ActiveSession): Boolean {
        val saved = prefs.edit()
            .clear()
            .putString(KEY_SESSION_ID, session.sessionId)
            .putLong(KEY_ENDS_AT_MILLIS, session.endsAtMillis)
            .putStringSet(KEY_BLOCKED_PACKAGES, session.blockedPackages)
            .putBoolean(KEY_END_SOUND_ON, session.endSoundOn)
            .putString(KEY_THEME_MODE, session.themeMode.channelValue)
            .commit()
        if (!saved) clear()
        return saved
    }

    fun clear(): Boolean = prefs.edit().clear().commit()

    fun read(): ActiveSession? {
        val sessionId = prefs.getString(KEY_SESSION_ID, null) ?: return null
        return ActiveSession(
            sessionId = sessionId,
            endsAtMillis = prefs.getLong(KEY_ENDS_AT_MILLIS, 0L),
            blockedPackages = prefs.getStringSet(KEY_BLOCKED_PACKAGES, null)?.toSet().orEmpty(),
            endSoundOn = prefs.getBoolean(KEY_END_SOUND_ON, true),
            themeMode = BlockThemeMode.fromChannelValue(prefs.getString(KEY_THEME_MODE, null))
                ?: BlockThemeMode.AUTO,
        )
    }

    fun active(nowMillis: Long = System.currentTimeMillis()): ActiveSession? =
        read()?.takeIf { it.isRunningAt(nowMillis) }

    private companion object {
        const val FILE_NAME = "focap_session"
        const val KEY_SESSION_ID = "sessionId"
        const val KEY_ENDS_AT_MILLIS = "endsAtMillis"
        const val KEY_BLOCKED_PACKAGES = "blockedPackages"
        const val KEY_END_SOUND_ON = "endSoundOn"
        const val KEY_THEME_MODE = "themeMode"
    }
}
