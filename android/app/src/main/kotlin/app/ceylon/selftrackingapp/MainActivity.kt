package app.ceylon.selftrackingapp

import android.Manifest
import android.content.pm.PackageManager
import android.os.AsyncTask
import android.os.Bundle
import android.os.Handler
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import app.ceylon.selftrackingapp.dao.LocationDao
import app.ceylon.selftrackingapp.model.LocationModel
import app.ceylon.selftrackingapp.service.LocationTrackingService
import com.google.android.gms.location.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*


class MainActivity : FlutterActivity() {
    companion object {
        const val CHANNEL = "app.ceylon.selftrackingapp.channel"
        const val LOCATION_UPDATE_REQUEST_CODE = 1554
        const val TAG = "MainActivity"
    }

    private var serviceConnected: Boolean = false
    private var locationService: LocationTrackingService? = null;

    private lateinit var client: FusedLocationProviderClient;
    private lateinit var locationDao: LocationDao;
    private val handler = Handler()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        client = LocationServices.getFusedLocationProviderClient(this)

        val permissionAccessCoarseLocationApproved = ActivityCompat
                .checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) ==
                PackageManager.PERMISSION_GRANTED

        if (permissionAccessCoarseLocationApproved) {
            // App has permission to access location in the foreground. Start your
            // foreground service that has a foreground service type of "location".
        } else {
            // Make a request for foreground-only location access.
            ActivityCompat.requestPermissions(this,
                    arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION),
                    LOCATION_UPDATE_REQUEST_CODE
            )
        }

        locationDao = LocationDatabase.getInstance(context).locationDao()

        val locationRequest = LocationRequest.create();
        locationRequest.interval = 1000
        locationRequest.fastestInterval = 20000
        locationRequest.smallestDisplacement = 0.0f
        locationRequest.priority = LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY

        client.requestLocationUpdates(locationRequest, object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                val location = locationResult.lastLocation
                val dateTime = Date(location.time)
                var locationModel = LocationModel(
                        date = dateTime,
                        dateString = dateTime.toString(),
                        lat = location.latitude,
                        lng = location.longitude);

                AsyncTask.execute {
                    locationDao.insert(locationModel)
                    handler.post {
                        Toast.makeText(context, "Location Updated ${locationModel.lng},${locationModel.lat},${locationModel.date?.time}", Toast.LENGTH_LONG).show()
                    }
                }
                Log.i(TAG, "Location store ${locationModel.lat},${locationModel.lng}")
            }
        }, mainLooper)

    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

//        EventChannel(flutterEngine.dartExecutor, "location").setStreamHandler(
//                object : EventChannel.StreamHandler {
//                    override fun onListen(args: Any, events: EventSink) {
//                        Log.w(TAG, "adding listener")
//                    }
//
//                    override fun onCancel(args: Any) {
//                        Log.w(TAG, "cancelling listener")
//                    }
//                }
//        )


        MethodChannel(flutterEngine.dartExecutor, "location").setMethodCallHandler { call, result ->
            if (call.method == "getLocation") {

                val handler = Handler()
                AsyncTask.execute {
                    val allLocations = locationDao.getAll();
                    var message = "";
                    for (location in allLocations) {
                        val locationResult: String = "${location.lng},${location.lat},${location.date?.time}"
                        message += locationResult;
                    }

                    handler.post {
                        result.success(message);
                    }
                }

            }
        }
    }


    private fun getLocationUpdate(): String? {
        val location = null//locationService?.getCurrentLocation();
        val locationResult: String? = ""//"${location?.longitude},${location?.latitude}"
        return locationResult
    }

}
