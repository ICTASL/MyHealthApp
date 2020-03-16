package app.ceylon.selftrackingapp.service

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

const val TAG = "LocationReceiver"

class LocationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val background = Intent(context, LocationTrackingService::class.java)
        Log.i(TAG,"Working on background");
        context.startService(background)
    }
}