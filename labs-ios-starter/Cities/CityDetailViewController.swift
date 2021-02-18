//
//  CityDetailViewController.swift
//  labs-ios-starter
//
//  Created by Conner on 2/16/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {
    // MARK: -- IBOutlets
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var rentLabel: UILabel!
    @IBOutlet weak var walkScoreLabel: UILabel!
    @IBOutlet weak var livabilityScoreLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    // MARK: -- Properties
    var city: City? = nil
    
    // MARK: -- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let city = city else { return }
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        navigationItem.title = city.city_name
        populationLabel.text = "Population: \(city.population)"
        rentLabel.text = "Monthly Rent: $\(city.rent_per_month)"
        walkScoreLabel.text = "Walk Score: \(city.walk_score)"
        livabilityScoreLabel.text = "Livability Score: \(city.livability_score)"
        
        requestImageForCity(cityName: city.city_name, completion: { (pixabayResultURL) in
            
            if let pixabayResultURL = pixabayResultURL {
                loadImage(urlString: pixabayResultURL, completion: { (img) in
                    if let img = img {
                        DispatchQueue.main.async {
                            self.image.image = img
                        }
                    }
                })
            }
            
        })
        
    }
}
