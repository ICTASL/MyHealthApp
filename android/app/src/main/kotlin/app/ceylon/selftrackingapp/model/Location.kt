package app.ceylon.selftrackingapp.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.*


@Entity
data class LocationModel(
        @ColumnInfo(name = "lat") val lat: Double?,
        @ColumnInfo(name = "lng") val lng: Double?,
        @ColumnInfo(name = "date") val date: Date?,
        @ColumnInfo(name = "date_string") val dateString: String?
) {

    @PrimaryKey(autoGenerate = true)
    var uid: Int = 0
}