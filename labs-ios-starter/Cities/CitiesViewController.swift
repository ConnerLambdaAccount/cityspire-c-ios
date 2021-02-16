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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cities: [String] = []
    var citySearchResults: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesCollectionView.dataSource = self
        citiesCollectionView.delegate = self
        fetchAllCities(completion: { (results) in
            self.cities = results
            self.citySearchResults = results
            DispatchQueue.main.async {
                self.citiesCollectionView.reloadData()
            }
        })
        searchBar.delegate = self
    }
}

extension CitiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as! CityCollectionViewCell
        
        let city: String = citySearchResults[indexPath.row]

        cell.cityStateLabel.text = city
        cell.populationLabel.text = "Population: 2.7M"
        cell.cityImageView.image = UIImage(named: "chicago")
        cell.cityImageView.contentMode = .scaleToFill
        cell.cityImageView.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citySearchResults.count
    }
}

extension CitiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredCities = cities.filter { (city) -> Bool in
            return city.lowercased().starts(with: searchText.lowercased())
        }
        self.citySearchResults = filteredCities
        self.citiesCollectionView.reloadData()
    }
}
