//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {

    var businesses: [Business]!

    @IBOutlet weak var businessTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        businessTableView.delegate = self
        businessTableView.dataSource = self
        
        businessTableView.estimatedRowHeight = 100
        businessTableView.rowHeight = UITableViewAutomaticDimension
        
        Business.search(with: "Thai") { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses

                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
                
                self.businessTableView.reloadData()
            }
        }

        // Example of Yelp search with more search options specified
        /*
        Business.search(with: "Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses

                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
        }
        */
    }

}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses == nil {
            return 0
        }
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = businessTableView.dequeueReusableCell(withIdentifier: "businessCell") as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
}
