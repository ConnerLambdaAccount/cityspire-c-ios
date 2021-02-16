//
//  City.swift
//  labs-ios-starter
//
//  Created by Conner on 2/15/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

struct City: Decodable {
    var city_name: String = ""
    var population: Int = -1
    var rent_per_month: Int = -1
    var walk_score: Int = -1
    var livability_score: Int = -1
}
