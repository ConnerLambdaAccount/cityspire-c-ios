//
//  LocationSearchTableViewController.swift
//  labs-ios-starter
//
//  Created by Claudia Maciel on 1/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

class LocationSearchTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

extension LocationSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
}
