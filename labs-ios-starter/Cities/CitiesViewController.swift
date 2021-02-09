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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}
