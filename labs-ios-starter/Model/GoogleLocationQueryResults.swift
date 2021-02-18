//
//  GoogleLocationQueryResults.swift
//  labs-ios-starter
//
//  Created by Conner on 2/18/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

struct GoogleLocationQueryResults: Decodable {
    let candidates: [Candidate]
    let status: String
}

struct Candidate: Decodable {
    let name: String
    let photos: [Photo]
}

struct Photo: Decodable {
    let height: Int
    let html_attributions: [String]
    let photo_reference: String
    let width: Int
}
