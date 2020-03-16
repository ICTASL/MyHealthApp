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
  
  let latitude: Double
  let longitude: Double
  let recordedAt: Date
  let title: String
  
  init(_ location: CLLocationCoordinate2D, date: Date) {
    latitude =  location.latitude
    longitude =  location.longitude
    self.recordedAt = date
    title = Location.dateFormatter.string(from: date)
  }
  
  static let dateFormatter: DateFormatter = {
     let formatter = DateFormatter()
     formatter.dateStyle = .medium
     formatter.timeStyle = .short
     return formatter
   }()
   
}
