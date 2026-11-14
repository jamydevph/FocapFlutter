package com.jamydevph.focapflutter

import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.util.AttributeSet
import android.view.View

class BlockRingsView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
) : View(context, attrs) {

    private val density = resources.displayMetrics.density
    private val outerRing = ringPaint(R.color.block_ring_outer)
    private val innerRing = ringPaint(R.color.block_ring_inner)

    var ringCenterY: Float = Float.NaN
        set(value) {
            if (field == value) return
            field = value
            invalidate()
        }

    override fun onDraw(canvas: Canvas) {
        if (ringCenterY.isNaN()) return
        val centerX = width / 2f
        canvas.drawCircle(centerX, ringCenterY, OUTER_RADIUS_DP * density, outerRing)
        canvas.drawCircle(centerX, ringCenterY, INNER_RADIUS_DP * density, innerRing)
    }

    private fun ringPaint(colorRes: Int) = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = density
        color = context.getColor(colorRes)
    }

    private companion object {
        const val OUTER_RADIUS_DP = 259.5f
        const val INNER_RADIUS_DP = 169.5f
    }
}
