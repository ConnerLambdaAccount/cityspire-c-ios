//
//  DSAPIHelpers.swift
//  labs-ios-starter
//
//  Created by Conner on 2/15/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

func fetchAllCities(completion: @escaping ([String]) -> () ) {
    
    struct Locations: Decodable {
        var locations: [String] = []
    }
    
    let baseURL: URL = URL(string: "http://cityspire-c-ds.eba-p3pw36sj.us-east-1.elasticbeanstalk.com/locations")!
    var request = URLRequest(url: baseURL)
    request.httpMethod = "GET"
    
    var decodedData = Locations()
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            NSLog("fetchAllCities(): error: \(error)")
            completion([])
            return
        }
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                
                guard let data = data else {
                    NSLog("fetchAllCities(): API Response 200, but no data received.")
                    completion([])
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    decodedData = try decoder.decode(Locations.self, from: data)
                } catch {
                    NSLog("fetchAllCities(): Error decoding cities into JSON.")
                    completion([])
                    return
                }
                
            } else {
                NSLog("fetchAllCities(): Response \(response.statusCode)")
                completion([])
                return
            }
        }
        completion(decodedData.locations)
    }.resume()
}
