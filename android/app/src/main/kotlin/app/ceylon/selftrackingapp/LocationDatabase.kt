package app.ceylon.selftrackingapp

import android.content.Context
import androidx.room.*
import app.ceylon.selftrackingapp.dao.LocationDao
import app.ceylon.selftrackingapp.model.LocationModel
import java.util.*


class Converters {
    @TypeConverter
    fun fromTimestamp(value: Long?): Date? {
        return value?.let { Date(it) }
    }

    @TypeConverter
    fun dateToTimestamp(date: Date?): Long? {
        return date?.time?.toLong()
    }
}

@Database(entities = [LocationModel::class], version = 1)
@TypeConverters(Converters::class)
abstract class LocationDatabase : RoomDatabase() {

    abstract fun locationDao(): LocationDao

    companion object {

        @Volatile private var INSTANCE: LocationDatabase? = null

        fun getInstance(context: Context): LocationDatabase =
                INSTANCE ?: synchronized(this) {
                    INSTANCE ?: buildDatabase(context).also { INSTANCE = it }
                }

        private fun buildDatabase(context: Context) =
                Room.databaseBuilder(context.applicationContext,
                        LocationDatabase::class.java, "covid_19_self_tracking_app")
                        .build()
    }
}