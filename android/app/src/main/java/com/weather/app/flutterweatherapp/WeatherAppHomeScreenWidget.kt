package com.weather.app.flutterweatherapp

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.widget.RemoteViews
import com.bumptech.glide.Glide
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.transition.Transition
import com.weather.app.flutterweatherapp.*

// New import.
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 * App Widget Configuration implemented in [WeatherAppHomeScreenWidgetConfigureActivity]
 */
class WeatherAppHomeScreenWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val view2 = RemoteViews(context.packageName, R.layout.weather_app_home_screen_widget)

            val title = widgetData.getString("city_name", null)
            view2.setTextViewText(R.id.headline_city, title ?: "")

            val description = widgetData.getString("temprature", null)
            view2.setTextViewText(
                R.id.headline_temprature,
                description + "\u2103" ?: "Weather info not found"
            )

            val imageIcon = widgetData.getString("weather_icon_url", "")


            val lastUpdate = widgetData.getString("last_update", null)
            view2.setTextViewText(
                R.id.headline_lastUpdate,
                ("Last updated at: $lastUpdate")
            )
            // Load the image asynchronously
            GlideApp.with(context.applicationContext)
                .asBitmap()
                .load(imageIcon)
                .into(object : CustomTarget<Bitmap>() {
                    override fun onResourceReady(
                        resource: Bitmap,
                        transition: Transition<in Bitmap>?
                    ) {
                        view2.setImageViewBitmap(R.id.imageId, resource)
                        updateUI(appWidgetManager, appWidgetId, view2)
                    }

                    override fun onLoadCleared(placeholder: Drawable?) {
                        // Handle the case where the image load is cancelled or fails
                    }
                })

            updateUI(appWidgetManager, appWidgetId, view2)

        }
    }


    private fun updateUI(
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        view2: RemoteViews
    ) {
        appWidgetManager.updateAppWidget(appWidgetId, view2)
    }


}
