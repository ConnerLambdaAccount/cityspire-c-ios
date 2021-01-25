//
//  ParseCities.swift
//  labs-ios-starter
//
//  Created by Conner on 1/24/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

// Parse cities from CSV file
func parseCities() -> [String] {
    let filePath = Bundle.main.path(forResource: "cities", ofType: "csv")!
    do {
        let fileContents = try String(contentsOf: URL(fileURLWithPath: filePath))
        // parse fileContents string into comma-separated substrings
        var cities: [String] = []
        
        var city = ""
        for c in fileContents {
            if c != "\n" { city.append(c) }
            if c == "," || c == "\n" {
                cities.append(city)
                city = ""
            }
        }
        return cities
    } catch {
        return []
    }
}
