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
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var livabilityScoreLabel: UILabel!
    
    
    // MARK: -- Properties
    var city: City? = nil
    
    // MARK: -- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let city = city else { return }
        cityImageView.layer.cornerRadius = 10
        cityImageView.clipsToBounds = true
        
        navigationItem.title = city.city_name
        populationLabel.text = "Population: \(city.population)"
        rentLabel.text = "Monthly Rent: $\(city.rent_per_month)"
        walkScoreLabel.text = "Walk Score: \(city.walk_score)"
        livabilityScoreLabel.text = "Livability Score: \(city.livability_score)"
        
        getImageURLRequestForCity(cityName: city.city_name, completion: { (urlRequest) in
            guard let urlRequest = urlRequest else { return }
            loadImage(urlRequest: urlRequest, completion: { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.cityImageView.image = image
                }
            })
        })
    }
}
