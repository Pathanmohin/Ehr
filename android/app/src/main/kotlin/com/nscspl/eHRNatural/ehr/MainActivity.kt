package com.nscspl.eHRNatural.ehr

import android.content.Context
import android.provider.Settings
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    private val USB_DEBUGGING_CHANNEL = "com.nscspl.eHRNatural/debugging"
    private val SUSPICIOUS_APPS_CHANNEL = "com.nscspl.eHRNatural/suspicious_apps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // USB Debugging Detection Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, USB_DEBUGGING_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "isUsbDebuggingEnabled") {
                val isEnabled = isUsbDebuggingEnabled()
                result.success(isEnabled)
            } else {
                result.notImplemented()
            }
        }

        // Suspicious Apps Detection Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SUSPICIOUS_APPS_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getInstalledApps") {
                val apps = getInstalledApps()
                result.success(apps)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun isUsbDebuggingEnabled(): Boolean {
        return Settings.Secure.getInt(contentResolver, Settings.Secure.ADB_ENABLED, 0) == 1
    }

    private fun getInstalledApps(): List<String> {
        val packageManager: PackageManager = packageManager
        val packages: List<PackageInfo> = packageManager.getInstalledPackages(0)
        return packages.map { it.packageName }
    }
}
