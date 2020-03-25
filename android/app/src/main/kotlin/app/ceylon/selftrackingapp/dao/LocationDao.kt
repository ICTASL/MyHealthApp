package app.ceylon.selftrackingapp.dao

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import app.ceylon.selftrackingapp.model.LocationModel
import java.util.*

@Dao
interface LocationDao {
    @Query("SELECT * FROM locationmodel")
    fun getAll(): List<LocationModel>

    @Query("SELECT * FROM locationmodel ORDER BY date DESC LIMIT 1")
    fun getLastLocation():LocationModel

    @Query("SELECT * FROM locationmodel WHERE date BETWEEN :startDate and :endDate")
    fun getAllByDateRange(startDate: Date, endDate: Date): List<LocationModel>

    @Insert
    fun insert(vararg locations: LocationModel)
}