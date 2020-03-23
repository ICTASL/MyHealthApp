package app.ceylon.selftrackingapp

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.AsyncTask
import android.os.Build
import android.os.Bundle
import android.os.Handler
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import app.ceylon.selftrackingapp.dao.LocationDao
import app.ceylon.selftrackingapp.service.LocationTrackingService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONObject


class MainActivity : FlutterActivity() {
    companion object {
        const val CHANNEL = "location"
        const val LOCATION_UPDATE_REQUEST_CODE = 1554
        const val TAG = "MainActivity"
    }


    private lateinit var locationDao: LocationDao;
    var isLocationServiceRunning = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this.flutterEngine!!);

        locationDao = LocationDatabase.getInstance(this).locationDao()




        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->


            if (call.method == "getLocation") {

                val handler = Handler()
                AsyncTask.execute {
                    val allLocations = locationDao.getAll();
                    var message = "";
                    val locaitons = ArrayList<String>(allLocations.size)
                    for (location in allLocations) {
                        val jsonLocation = JSONObject()
                        jsonLocation.put("longitude", location.lng)
                        jsonLocation.put("latitude", location.lat)
                        jsonLocation.put("recordedAt", location.date?.time)
                        jsonLocation.put("title", location.dateString)
                        locaitons.add(jsonLocation.toString(10))
                    }

                    handler.post {
                        result.success(locaitons);
                    }
                }

            } else if (call.method == "requestLocationPermission") {
                val permissionAccessCoarseLocationApproved = ActivityCompat
                        .checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) ==
                        PackageManager.PERMISSION_GRANTED

                if (permissionAccessCoarseLocationApproved) {
                    result.success("PERMISSION_GRANTED");
                } else {
                    // Make a request for foreground-only location access.
                    ActivityCompat.requestPermissions(this,
                            arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION),
                            LOCATION_UPDATE_REQUEST_CODE
                    )
                    result.success("PERMISSION_GRANTED");
                }
            } else if (call.method == "openLocationService") {
                if (!isLocationServiceRunning)
                    Intent(this, LocationTrackingService::class.java).also { intent ->
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startForegroundService(intent)
                        } else {
                            startService(intent);
                        }
                        isLocationServiceRunning = true
                    }
                result.success("LOCATION_SERVICE_RUNNING");
            }
        }

    }


    private fun getLocationUpdate(): String? {
        val location = null//locationService?.getCurrentLocation();
        val locationResult: String? = ""//"${location?.longitude},${location?.latitude}"
        return locationResult
    }


}
