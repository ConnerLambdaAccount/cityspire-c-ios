//
//  GooglePlacesAPIHelpers.swift
//  labs-ios-starter
//
//  Created by Conner on 2/18/21.
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

func getImageURLRequestForCity(cityName: String, completion: @escaping (URLRequest?) -> () ) {
    var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/place/")!
    urlComponents.queryItems = [URLQueryItem(name: "key", value: "AIzaSyAF_RSxBaOS7dq62VJJO2p-bX718q3P2lM"),
                                URLQueryItem(name: "input", value: cityName),
                                URLQueryItem(name: "inputtype", value: "textquery"),
                                URLQueryItem(name: "fields", value: "name,photos")
              ]
    
    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = "GET"
    request.url!.appendPathComponent("findplacefromtext/json")
    
    var imageURLRequest: URLRequest? = nil
    
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
                    let decodedData = try JSONDecoder().decode(GoogleLocationQueryResults.self, from: data)
                    if decodedData.candidates.count > 0 && decodedData.candidates[0].photos.count > 0 {
                        let photoReference = decodedData.candidates[0].photos[0].photo_reference
                        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/place/photo")!
                        
                        components.queryItems = [URLQueryItem(name: "key", value: "AIzaSyAF_RSxBaOS7dq62VJJO2p-bX718q3P2lM"),
                                                    URLQueryItem(name: "photoreference", value: photoReference),
                                                    URLQueryItem(name: "maxwidth", value: "800"),
                                                    URLQueryItem(name: "maxheight", value: "800")
                                  ]
                        
                        imageURLRequest = URLRequest(url: urlComponents.url!)
                        imageURLRequest!.httpMethod = "GET"
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
        completion(imageURLRequest)
    }.resume()
}
