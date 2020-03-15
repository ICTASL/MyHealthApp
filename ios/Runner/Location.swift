//
//  Location.swift
//  Runner
//
//  Created by Udesh Kumarasinghe on 3/15/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import CoreLocation

class Location: Codable {
  
  let lat: Double
  let lng: Double
  let date: Date
  let dateString: String
  
  init(_ location: CLLocationCoordinate2D, date: Date) {
    lat =  location.latitude
    lng =  location.longitude
    self.date = date
    dateString = Location.dateFormatter.string(from: date)
  }
  
  static let dateFormatter: DateFormatter = {
     let formatter = DateFormatter()
     formatter.dateStyle = .medium
     formatter.timeStyle = .medium
     return formatter
   }()
   
}
