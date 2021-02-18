//
//  CitiesViewController.swift
//  labs-ios-starter
//
//  Created by Conner on 2/8/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class CitiesCollectionViewController: UIViewController {
    // MARK: -- IBOutlets
    @IBOutlet var citiesCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: -- Properties
    var cities: [String] = []
    var citySearchResults: [String] = []
    var selectedCity: City? = nil
    
    // MARK: -- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesCollectionView.dataSource = self
        citiesCollectionView.delegate = self
        searchBar.delegate = self
        
        fetchAllCities(completion: { (results) in
            self.cities = results
            self.citySearchResults = results
            DispatchQueue.main.async {
                self.citiesCollectionView.reloadData()
            }
        })
        
    }
}

extension CitiesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: -- CellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as! CityCollectionViewCell
        
        let city: String = citySearchResults[indexPath.row]

        cell.cityStateLabel.text = city
        cell.cityImageView.contentMode = .scaleToFill
        cell.cityImageView.layer.cornerRadius = 15
        
        getImageURLRequestForCity(cityName: city, completion: { (urlRequest) in
            guard let urlRequest = urlRequest else { return }
            loadImage(urlRequest: urlRequest, completion: { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    cell.cityImageView.image = image
                }
            })
        })
        
        return cell
    }
    
    // MARK: -- NumberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citySearchResults.count
    }
    
    // Mark: -- DidSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchSingleCity(cityName: citySearchResults[indexPath.row], completion: { (city) in
            if let city = city {
                self.selectedCity = city
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "CityDetailSegue", sender: nil)
                }
            }
        })
    }
    
}

extension CitiesCollectionViewController: UISearchBarDelegate {
    // Mark: -- TextDidChange
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredCities = cities.filter { (city) -> Bool in
            return city.lowercased().starts(with: searchText.lowercased())
        }
        self.citySearchResults = filteredCities
        self.citiesCollectionView.reloadData()
    }
}

extension CitiesCollectionViewController {
    // MARK: -- prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CityDetailSegue" {
            if let selectedCity = selectedCity, let destinationVC = segue.destination as? CityDetailViewController {
                destinationVC.city = selectedCity
            }
        }
    }
}
