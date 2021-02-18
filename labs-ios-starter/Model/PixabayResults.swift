//
//  PixabayResults.swift
//  labs-ios-starter
//
//  Created by Conner on 2/17/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

// MARK: - Pixabay Results
struct PixabayResults: Decodable {
    var total, totalHits: Int
    var hits: [Hit]
}

// MARK: - Hit
struct Hit: Decodable {
    var id: Int
    var pageURL: String
    var type, tags: String
    var previewURL: String
    var previewWidth, previewHeight: Int
    var webformatURL: String
    var webformatWidth, webformatHeight: Int
    var largeImageURL: String
    var imageWidth, imageHeight, imageSize, views: Int
    var downloads, favorites, likes, comments: Int
    var user_id: Int
    var user: String
    var userImageURL: String
}
