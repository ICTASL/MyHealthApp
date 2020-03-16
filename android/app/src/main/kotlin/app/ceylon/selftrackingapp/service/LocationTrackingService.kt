package app.ceylon.selftrackingapp.service

import android.R
import android.app.Service
import android.content.Intent
import android.location.Location
import android.os.Bundle
import android.os.IBinder
import android.os.Looper
import android.widget.Toast
import com.google.android.gms.location.*
import com.google.android.gms.location.LocationServices.getFusedLocationProviderClient


class LocationTrackingService : Service() {




    override fun onBind(intent: Intent?): IBinder? {
        return null
    }



}