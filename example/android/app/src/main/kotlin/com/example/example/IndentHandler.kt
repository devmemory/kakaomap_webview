package com.example.example

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class IndentHandler(private val activity: Activity) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val url: String = call.argument("url") ?: return

        if (url.startsWith("intent://")) {
            try {
                val intent: Intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME)

                Log.d("[Intent] package", intent.`package`.toString())

                val existPackage =
                    activity.packageManager.getLaunchIntentForPackage(intent.`package`.toString())

                Log.d("[Intent] exist package", existPackage.toString())

                if (existPackage != null) {
                    activity.startActivity(intent)
                } else {
                    val marketIntent = Intent(Intent.ACTION_VIEW)
                    marketIntent.data = Uri.parse("market://details?id=" + intent.`package`)
                    activity.startActivity(marketIntent)
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}