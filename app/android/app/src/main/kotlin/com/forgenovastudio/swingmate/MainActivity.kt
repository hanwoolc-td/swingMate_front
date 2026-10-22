package com.forgenovastudio.swingmate

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build
import java.util.UUID

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "swingmate/device_info")
            .setMethodCallHandler { call, result ->
                if (call.method != "getDeviceInfo") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val manufacturer = Build.MANUFACTURER.orEmpty()
                    .replaceFirstChar { if (it.isLowerCase()) it.titlecase() else it.toString() }
                val model = Build.MODEL.orEmpty()
                val name = if (model.startsWith(manufacturer, ignoreCase = true)) model
                    else "$manufacturer $model".trim()
                val version = packageManager.getPackageInfo(packageName, 0).versionName
                val preferences = getSharedPreferences("swingmate_device", MODE_PRIVATE)
                val deviceId = preferences.getString("install_id", null) ?: UUID.randomUUID().toString().also {
                    preferences.edit().putString("install_id", it).apply()
                }
                result.success(mapOf(
                    "deviceId" to deviceId,
                    "deviceName" to name.take(120),
                    "platform" to "ANDROID",
                    "appVersion" to version,
                ))
            }
    }
}
