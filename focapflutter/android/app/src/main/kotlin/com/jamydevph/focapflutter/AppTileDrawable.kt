package com.jamydevph.focapflutter

import android.graphics.Canvas
import android.graphics.ColorFilter
import android.graphics.PixelFormat
import android.graphics.Rect
import android.graphics.drawable.AdaptiveIconDrawable
import android.graphics.drawable.Drawable
import kotlin.math.roundToInt

class AppTileDrawable(source: Drawable) : Drawable() {

    private val icon: Drawable = source.mutate()
    private val parts: List<Drawable> =
        if (icon is AdaptiveIconDrawable) {
            listOfNotNull(icon.background?.mutate(), icon.foreground?.mutate())
        } else {
            listOf(icon)
        }

    override fun draw(canvas: Canvas) {
        val tile = bounds
        if (tile.isEmpty) return
        if (icon is AdaptiveIconDrawable) {
            val bleed = (tile.width() * ADAPTIVE_BLEED).roundToInt()
            val layerBounds = Rect(tile.left - bleed, tile.top - bleed, tile.right + bleed, tile.bottom + bleed)
            parts.forEach { layer ->
                layer.bounds = layerBounds
                layer.draw(canvas)
            }
        } else {
            val size = (tile.width() * LEGACY_ICON_SCALE).roundToInt()
            val left = tile.left + (tile.width() - size) / 2
            val top = tile.top + (tile.height() - size) / 2
            icon.setBounds(left, top, left + size, top + size)
            icon.draw(canvas)
        }
    }

    override fun setAlpha(alpha: Int) {
        parts.forEach { it.alpha = alpha }
        invalidateSelf()
    }

    override fun setColorFilter(colorFilter: ColorFilter?) {
        parts.forEach { it.colorFilter = colorFilter }
        invalidateSelf()
    }

    @Deprecated("Deprecated in Java")
    override fun getOpacity(): Int = PixelFormat.TRANSLUCENT

    override fun getIntrinsicWidth(): Int = -1

    override fun getIntrinsicHeight(): Int = -1

    private companion object {
        const val ADAPTIVE_BLEED = 0.25f
        const val LEGACY_ICON_SCALE = 0.64f
    }
}
