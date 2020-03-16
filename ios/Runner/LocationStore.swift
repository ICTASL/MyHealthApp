//
//  LocationStore.swift
//  Runner
//
//  Created by Udesh Kumarasinghe on 3/15/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import CoreLocation

class LocationsStorage {
  static let shared = LocationsStorage()
  
  private(set) var locations: [Location]
  private let fileManager: FileManager
  private let documentsURL: URL
  
  init() {
    let fileManager = FileManager.default
    documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    self.fileManager = fileManager
    
    let jsonDecoder = JSONDecoder()
    
    let locationFilesURLs = try! fileManager.contentsOfDirectory(at: documentsURL,
                                                                 includingPropertiesForKeys: nil)
    locations = locationFilesURLs.compactMap { url -> Location? in
      guard !url.absoluteString.contains(".DS_Store") else {
        return nil
      }
      guard let data = try? Data(contentsOf: url) else {
        return nil
      }
      return try? jsonDecoder.decode(Location.self, from: data)
    }.sorted(by: { $0.date < $1.date })
  }
  
  func saveLocationOnDisk(location: Location) {
    let encoder = JSONEncoder()
    let timestamp = location.date.timeIntervalSince1970
    let fileURL = documentsURL.appendingPathComponent("\(timestamp)")
    
    let data = try! encoder.encode(location)
    try! data.write(to: fileURL)
    
    locations.append(location)
  }
}


