package `in`.wellwish.partner_app

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "in.wellwish.partner/device")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "looksRooted" -> result.success(looksRooted())
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Signs of a rooted phone (ARCHITECTURE §12): a build signed with test keys, an `su` binary
     * or Magisk's folders. The app only warns: a determined user can hide root from any check.
     */
    private fun looksRooted(): Boolean {
        if (Build.TAGS?.contains("test-keys") == true) return true
        return ROOT_PATHS.any { path -> runCatching { File(path).exists() }.getOrDefault(false) }
    }

    private companion object {
        val ROOT_PATHS = listOf(
            "/system/bin/su",
            "/system/xbin/su",
            "/sbin/su",
            "/su/bin/su",
            "/system/su",
            "/system/bin/failsafe/su",
            "/system/sd/xbin/su",
            "/data/local/su",
            "/data/local/bin/su",
            "/data/local/xbin/su",
            "/vendor/bin/su",
            "/system/app/Superuser.apk",
            "/system/app/SuperSU.apk",
            "/data/adb/magisk",
            "/sbin/.magisk",
            "/cache/.disable_magisk",
        )
    }
}
