//
//  PixabayAPIHelpers.swift
//  labs-ios-starter
//
//  Created by Conner on 2/17/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation
import UIKit

func loadImage(urlString: String, completion: @escaping (UIImage?) -> () ) {
    let imageURL: URL = URL(string: urlString)!
    let request: URLRequest = URLRequest(url: imageURL)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if error != nil {
            NSLog("loadImage(): error: \(error!)")
            completion(nil)
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            NSLog("loadImage(): Response could not be casted to HTTPURLResponse")
            completion(nil)
            return
        }
        
        if response.statusCode != 200 {
            NSLog("loadImage(): Unexpected response code \(response.statusCode)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            NSLog("loadImage(): Data is nil")
            completion(nil)
            return
        }
        
        completion(UIImage(data: data))
    }.resume()
}

func requestImageForCity(cityName: String, completion: @escaping (String?) -> () ) {
    var urlComponents = URLComponents(string: "https://pixabay.com/api/")!
    
    urlComponents.queryItems = [URLQueryItem(name: "key", value: "20315394-d316c94426417fcecac0986c2"),
                                URLQueryItem(name: "q", value: cityName),
                                URLQueryItem(name: "image_type", value: "photo"),
                                URLQueryItem(name: "safesearch", value: "true")
              ]
    
    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = "GET"
    
    var imageURL: String? = nil
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            NSLog("requestImageForCity(): error: \(error)")
            completion(nil)
            return
        }
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                guard let data = data else {
                    print("requestImageForCity(): API Response 200, but no data received.")
                    completion(nil)
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(PixabayResults.self, from: data)
                    // Grab first result from the JSON response
                    if decodedData.hits.count > 0 {
                        imageURL = decodedData.hits[0].webformatURL
                    }
                    
                } catch {
                    print("requestImageForCity(): Error decoding hits from JSON.")
                    completion(nil)
                    return
                }
                
            } else {
                print("requestImageForCity(): Unexpected Response \(response.statusCode)")
                completion(nil)
                return
            }
        }
        completion(imageURL)
    }.resume()
}

