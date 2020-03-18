package app.ceylon.selftrackingapp.service

import android.app.Service
import android.content.Intent
import android.location.Location
import android.os.*
import android.util.Log
import android.widget.Toast
import app.ceylon.selftrackingapp.LocationDatabase
import app.ceylon.selftrackingapp.MainActivity
import app.ceylon.selftrackingapp.dao.LocationDao
import app.ceylon.selftrackingapp.model.LocationModel
import com.google.android.gms.location.*
import java.util.*


class LocationTrackingService : Service() {

    private val binder: IBinder = AppServiceBinder()

    inner class AppServiceBinder : Binder() {
        val service: LocationTrackingService
            get() = this@LocationTrackingService
    }

    override fun onBind(intent: Intent?): IBinder? {
        return binder
    }

    private lateinit var locationDao: LocationDao;
    private val handler = Handler()

    override fun onCreate() {
        locationDao = LocationDatabase.getInstance(this).locationDao()
        startLocationUpdates();
    }

    private var mLocationRequest: LocationRequest? = null

    private val UPDATE_INTERVAL = 20 * 60 * 1 * 1000 /* 10 secs */.toLong()
    private val FASTEST_INTERVAL: Long = 1 * 60 * 1 * 1000 /* 2 sec */


    // Trigger new location updates at interval
    protected fun startLocationUpdates() { // Create the location request to start receiving updates
        mLocationRequest = LocationRequest()
        mLocationRequest!!.priority = LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY
        mLocationRequest!!.interval = UPDATE_INTERVAL
        mLocationRequest!!.fastestInterval = FASTEST_INTERVAL
        // Create LocationSettingsRequest object using location request
        val builder = LocationSettingsRequest.Builder()
        builder.addLocationRequest(mLocationRequest!!)
        val locationSettingsRequest = builder.build()
        // Check whether location settings are satisfied
// https://developers.google.com/android/reference/com/google/android/gms/location/SettingsClient
        val settingsClient = LocationServices.getSettingsClient(this)
        settingsClient.checkLocationSettings(locationSettingsRequest)
        // new Google API SDK v11 uses getFusedLocationProviderClient(this)
        LocationServices.getFusedLocationProviderClient(this).requestLocationUpdates(mLocationRequest, object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) { // do work here
                onLocationChanged(locationResult.lastLocation)
            }
        },
                Looper.myLooper())
    }

    fun onLocationChanged(location: Location) { // New location has now been determined

        val dateTime = Date(location.time)
        var locationModel = LocationModel(
                date = dateTime,
                dateString = dateTime.toString(),
                lat = location.latitude,
                lng = location.longitude);

        AsyncTask.execute {
            locationDao.insert(locationModel)
            handler.post {
                //                Toast.makeText(this, "Location Updated ${locationModel.lng},${locationModel.lat},${locationModel.date?.time}", Toast.LENGTH_LONG).show()
            }
        }
        Log.i(MainActivity.TAG, "Location store ${locationModel.lat},${locationModel.lng}")
        // You can now create a LatLng Object for use with maps

    }
}