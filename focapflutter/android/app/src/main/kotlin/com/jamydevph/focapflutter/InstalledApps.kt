package com.jamydevph.focapflutter

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.AdaptiveIconDrawable
import android.graphics.drawable.Drawable
import android.provider.Settings
import android.telecom.TelecomManager
import java.io.ByteArrayOutputStream
import java.text.Collator
import kotlin.math.min
import kotlin.math.roundToInt

class InstalledApps(private val context: Context) {

    fun list(): List<Map<String, Any>> {
        val packageManager = context.packageManager
        val neverBlockable = neverBlockablePackages(context)
        val iconSizePx = min(
            (ICON_SIZE_DP * context.resources.displayMetrics.density).roundToInt(),
            MAX_ICON_SIZE_PX,
        )
        val launcherIntent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        val collator = Collator.getInstance()

        return packageManager.queryIntentActivities(launcherIntent, 0)
            .groupBy { it.activityInfo.packageName }
            .filterKeys { it !in neverBlockable }
            .map { (packageName, activities) ->
                AppEntry(
                    packageName = packageName,
                    label = labelOf(packageManager, packageName, activities),
                    icon = iconOf(packageManager, activities.first(), iconSizePx),
                )
            }
            .sortedWith(compareBy(collator) { entry: AppEntry -> entry.label }.thenBy { it.packageName })
            .map { it.toMap() }
    }

    private fun labelOf(
        packageManager: PackageManager,
        packageName: String,
        activities: List<ResolveInfo>,
    ): String = runCatching {
        val label = if (activities.size == 1) {
            activities.first().loadLabel(packageManager)
        } else {
            activities.first().activityInfo.applicationInfo.loadLabel(packageManager)
        }
        label.toString().ifBlank { packageName }
    }.getOrDefault(packageName)

    private fun iconOf(packageManager: PackageManager, activity: ResolveInfo, sizePx: Int): ByteArray =
        runCatching { pngBytes(activity.loadIcon(packageManager), sizePx) }.getOrDefault(ByteArray(0))

    private fun pngBytes(drawable: Drawable, sizePx: Int): ByteArray {
        val bitmap = Bitmap.createBitmap(sizePx, sizePx, Bitmap.Config.ARGB_8888)
        try {
            val icon = drawable.mutate()
            val width = icon.intrinsicWidth
            val height = icon.intrinsicHeight
            if (icon is AdaptiveIconDrawable || width <= 0 || height <= 0) {
                icon.setBounds(0, 0, sizePx, sizePx)
            } else {
                val scale = sizePx.toFloat() / maxOf(width, height)
                val drawnWidth = (width * scale).roundToInt()
                val drawnHeight = (height * scale).roundToInt()
                val left = (sizePx - drawnWidth) / 2
                val top = (sizePx - drawnHeight) / 2
                icon.setBounds(left, top, left + drawnWidth, top + drawnHeight)
            }
            icon.draw(Canvas(bitmap))
            val output = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 0, output)
            return output.toByteArray()
        } finally {
            bitmap.recycle()
        }
    }

    private data class AppEntry(val packageName: String, val label: String, val icon: ByteArray) {
        fun toMap(): Map<String, Any> = mapOf("packageName" to packageName, "label" to label, "icon" to icon)
    }

    companion object {
        private const val ICON_SIZE_DP = 48
        private const val MAX_ICON_SIZE_PX = 144
        private const val ANDROID_RESOLVER = "android"

        fun neverBlockablePackages(context: Context): Set<String> {
            val packageManager = context.packageManager
            fun handlers(intent: Intent): List<String> = packageManager
                .queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
                .map { it.activityInfo.packageName }

            val defaultDialer = context.getSystemService(TelecomManager::class.java)?.defaultDialerPackage

            return buildSet {
                add(context.packageName)
                addAll(handlers(Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)))
                addAll(handlers(Intent(Settings.ACTION_SETTINGS)))
                addAll(handlers(Intent(Intent.ACTION_DIAL)))
                defaultDialer?.let(::add)
                remove(ANDROID_RESOLVER)
            }
        }
    }
}
