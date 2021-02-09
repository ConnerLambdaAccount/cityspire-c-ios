//
//  CitiesViewController.swift
//  labs-ios-starter
//
//  Created by Conner on 2/8/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {
    @IBOutlet var citiesCollectionView: UICollectionView!
    override func viewDidLoad() {
        citiesCollectionView.dataSource = self
        citiesCollectionView.delegate = self
    }
}

extension CitiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as! CityCollectionViewCell
        cell.cityStateLabel.text = "Chicago, IL"
        cell.populationLabel.text = "Population: 2.7M"
        cell.cityImageView.image = UIImage(systemName: "building.2.fill")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}
