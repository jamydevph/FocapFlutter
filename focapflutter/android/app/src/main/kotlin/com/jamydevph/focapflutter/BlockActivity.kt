package com.jamydevph.focapflutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.icu.text.MeasureFormat
import android.icu.util.Measure
import android.icu.util.MeasureUnit
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.view.WindowInsets
import android.view.accessibility.AccessibilityNodeInfo
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.window.OnBackInvokedCallback
import android.window.OnBackInvokedDispatcher
import java.util.Locale

class BlockActivity : Activity() {

    private val ticker = Handler(Looper.getMainLooper())
    private var endsAtMillis = 0L
    private var backCallback: OnBackInvokedCallback? = null

    private val tick = object : Runnable {
        override fun run() {
            val remainingMillis = showTimeLeft()
            if (remainingMillis > 0L) {
                ticker.postDelayed(this, millisToNextSecond(remainingMillis))
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        drawBehindSystemBars()
        setContentView(R.layout.activity_block)
        applySystemBarInsets()
        applyFonts()
        findViewById<View>(R.id.block_app_icon).clipToOutline = true
        findViewById<View>(R.id.block_go_home).apply {
            setOnClickListener { goHome() }
            accessibilityDelegate = ButtonRoleDelegate
        }
        registerBackAsGoHome()
        keepRingsCenteredOnTile()
        bind(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        bind(intent)
    }

    override fun onStart() {
        super.onStart()
        ticker.removeCallbacks(tick)
        ticker.post(tick)
    }

    override fun onStop() {
        ticker.removeCallbacks(tick)
        super.onStop()
    }

    override fun onDestroy() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            backCallback?.let(onBackInvokedDispatcher::unregisterOnBackInvokedCallback)
        }
        super.onDestroy()
    }

    @Deprecated("Back before Android 13 still arrives here")
    override fun onBackPressed() {
        goHome()
    }

    private fun bind(intent: Intent) {
        val blockedPackage = intent.getStringExtra(EXTRA_BLOCKED_PACKAGE).orEmpty()
        endsAtMillis = intent.getLongExtra(EXTRA_ENDS_AT_MILLIS, 0L)
        val (label, icon) = appIdentity(blockedPackage)
        val title = getString(R.string.block_title, label)
        findViewById<TextView>(R.id.block_title).text = title
        setTitle(title)
        findViewById<ImageView>(R.id.block_app_icon).setImageDrawable(icon?.let(::AppTileDrawable))
        findViewById<View>(R.id.block_time_card).visibility =
            if (endsAtMillis > 0L) View.VISIBLE else View.GONE
        ticker.removeCallbacks(tick)
        ticker.post(tick)
    }

    private fun appIdentity(blockedPackage: String): Pair<String, Drawable?> = runCatching {
        val launcherEntries = packageManager.queryIntentActivities(
            Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER).setPackage(blockedPackage),
            0,
        )
        val appInfo = packageManager.getApplicationInfo(blockedPackage, 0)
        val label = if (launcherEntries.size == 1) {
            launcherEntries.first().loadLabel(packageManager)
        } else {
            packageManager.getApplicationLabel(appInfo)
        }
        val icon = launcherEntries.firstOrNull()?.loadIcon(packageManager)
            ?: packageManager.getApplicationIcon(appInfo)
        label.toString().ifBlank { blockedPackage } to icon
    }.getOrDefault(blockedPackage to null)

    private fun showTimeLeft(): Long {
        if (endsAtMillis <= 0L) return 0L
        val remainingMillis = (endsAtMillis - System.currentTimeMillis()).coerceAtLeast(0L)
        val totalSeconds = (remainingMillis + MILLIS_PER_SECOND - 1) / MILLIS_PER_SECOND
        val hours = totalSeconds / SECONDS_PER_HOUR
        val minutes = (totalSeconds % SECONDS_PER_HOUR) / SECONDS_PER_MINUTE
        val seconds = totalSeconds % SECONDS_PER_MINUTE
        findViewById<TextView>(R.id.block_time).text = if (hours > 0) {
            String.format(Locale.ROOT, "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            String.format(Locale.ROOT, "%02d:%02d", minutes, seconds)
        }
        findViewById<View>(R.id.block_time_card).contentDescription =
            getString(R.string.block_time_left_spoken, spokenDuration(hours, minutes, seconds))
        return remainingMillis
    }

    private fun spokenDuration(hours: Long, minutes: Long, seconds: Long): String {
        val parts = buildList {
            if (hours > 0) add(Measure(hours, MeasureUnit.HOUR))
            if (hours > 0 || minutes > 0) add(Measure(minutes, MeasureUnit.MINUTE))
            add(Measure(seconds, MeasureUnit.SECOND))
        }
        return MeasureFormat.getInstance(Locale.getDefault(), MeasureFormat.FormatWidth.WIDE)
            .formatMeasures(*parts.toTypedArray())
    }

    private fun millisToNextSecond(remainingMillis: Long): Long {
        val intoSecond = remainingMillis % MILLIS_PER_SECOND
        return if (intoSecond == 0L) MILLIS_PER_SECOND else intoSecond
    }

    private fun goHome() {
        val home = Intent(Intent.ACTION_MAIN)
            .addCategory(Intent.CATEGORY_HOME)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        runCatching { startActivity(home) }
        finish()
    }

    private fun registerBackAsGoHome() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return
        val callback = OnBackInvokedCallback { goHome() }
        onBackInvokedDispatcher.registerOnBackInvokedCallback(
            OnBackInvokedDispatcher.PRIORITY_DEFAULT,
            callback,
        )
        backCallback = callback
    }

    private fun keepRingsCenteredOnTile() {
        val root = findViewById<View>(R.id.block_root)
        val rings = findViewById<BlockRingsView>(R.id.block_rings)
        val tile = findViewById<View>(R.id.block_tile_area)
        val ringOffsetPx = RING_OFFSET_BELOW_TILE_DP * resources.displayMetrics.density
        val placeRings = {
            val rootLocation = IntArray(2).also(root::getLocationInWindow)
            val tileLocation = IntArray(2).also(tile::getLocationInWindow)
            val tileCenterY = tileLocation[1] - rootLocation[1] + tile.height / 2f
            rings.ringCenterY = tileCenterY + ringOffsetPx
        }
        root.addOnLayoutChangeListener { _, _, _, _, _, _, _, _, _ -> placeRings() }
        findViewById<View>(R.id.block_scroll).setOnScrollChangeListener { _, _, _, _, _ -> placeRings() }
    }

    private fun applyFonts() {
        val regular = poppins("Regular")
        val semiBold = poppins("SemiBold")
        val bold = poppins("Bold")
        bold?.let {
            findViewById<TextView>(R.id.block_title).typeface = it
            findViewById<TextView>(R.id.block_time).typeface = it
        }
        regular?.let {
            findViewById<TextView>(R.id.block_subtitle).typeface = it
            findViewById<TextView>(R.id.block_time_label).typeface = it
            findViewById<TextView>(R.id.block_footnote).typeface = it
        }
        semiBold?.let { findViewById<TextView>(R.id.block_go_home_label).typeface = it }
    }

    private fun poppins(weight: String): Typeface? = runCatching {
        Typeface.createFromAsset(assets, "$FLUTTER_FONTS/Poppins-$weight.ttf")
    }.getOrNull()

    @Suppress("DEPRECATION")
    private fun drawBehindSystemBars() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            window.setDecorFitsSystemWindows(false)
        } else {
            window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
                View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or
                View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
        }
    }

    private fun applySystemBarInsets() {
        val column = findViewById<View>(R.id.block_column)
        val sidePadding = column.paddingStart
        val bottomPadding = column.paddingBottom
        column.setOnApplyWindowInsetsListener { view, insets ->
            val (left, top, right, bottom) = systemBarInsets(insets)
            view.setPadding(sidePadding + left, top, sidePadding + right, bottomPadding + bottom)
            insets
        }
        column.requestApplyInsets()
    }

    @Suppress("DEPRECATION")
    private fun systemBarInsets(insets: WindowInsets): List<Int> =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val bars = insets.getInsets(WindowInsets.Type.systemBars() or WindowInsets.Type.displayCutout())
            listOf(bars.left, bars.top, bars.right, bars.bottom)
        } else {
            listOf(
                insets.systemWindowInsetLeft,
                insets.systemWindowInsetTop,
                insets.systemWindowInsetRight,
                insets.systemWindowInsetBottom,
            )
        }

    private object ButtonRoleDelegate : View.AccessibilityDelegate() {
        override fun onInitializeAccessibilityNodeInfo(host: View, info: AccessibilityNodeInfo) {
            super.onInitializeAccessibilityNodeInfo(host, info)
            info.className = Button::class.java.name
        }
    }

    companion object {
        private const val EXTRA_BLOCKED_PACKAGE = "com.jamydevph.focapflutter.extra.BLOCKED_PACKAGE"
        private const val EXTRA_ENDS_AT_MILLIS = "com.jamydevph.focapflutter.extra.ENDS_AT_MILLIS"
        private const val FLUTTER_FONTS = "flutter_assets/assets/fonts"
        private const val MILLIS_PER_SECOND = 1000L
        private const val SECONDS_PER_MINUTE = 60L
        private const val SECONDS_PER_HOUR = 3600L
        private const val RING_OFFSET_BELOW_TILE_DP = 80f

        fun intent(context: Context, blockedPackage: String, endsAtMillis: Long): Intent =
            Intent(context, BlockActivity::class.java)
                .putExtra(EXTRA_BLOCKED_PACKAGE, blockedPackage)
                .putExtra(EXTRA_ENDS_AT_MILLIS, endsAtMillis)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
    }
}
