package app.ceylon.selftrackingapp

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    companion object {
        const val CHANNEL = "app.ceylon.selftrackingapp.channel"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);


        MethodChannel(flutterEngine.dartExecutor, "location").setMethodCallHandler { call, result ->
            if (call.method == "getLocation") {
                val location = getLocationUpdate()

                if (location != null) {
                    result.success(location)
                } else {
                    result.error("Unavailable", "Location is not available", null)
                }
            }
        }
    }

    private fun getLocationUpdate(): String? {
        val locationResult: String? = "FROM SERVER"
        return locationResult
    }
}
