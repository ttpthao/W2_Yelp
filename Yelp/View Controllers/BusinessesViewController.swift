//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    let searchBar = UISearchBar()
    let refreshControl = UIRefreshControl()
    
    let navigationBarColor = UIColor(red: 21/255, green: 194/255, blue: 179/255, alpha: 1)
    
    @IBOutlet weak var businessTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.sizeToFit()
        self.searchBar.placeholder = "Restaurants"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.barTintColor = navigationBarColor
        
        //pull to refresh
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        businessTableView.insertSubview(refreshControl, at: 0)
        
        businessTableView.delegate = self
        businessTableView.dataSource = self
        
        businessTableView.estimatedRowHeight = 100
        businessTableView.rowHeight = UITableViewAutomaticDimension
        
        fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationVC = segue.destination as! UINavigationController
        let filterVC = navigationVC.topViewController as! FiltersViewController
        filterVC.delegate = self
    }
    
    func fetchData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Business.search(with: searchBar.text!, sort: BusinessFilterSettings.sharedIntance.sort, categories: BusinessFilterSettings.sharedIntance.categories, deals: BusinessFilterSettings.sharedIntance.deals, distance: BusinessFilterSettings.sharedIntance.distance) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                
                self.businessTableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
                self.refreshControl.endRefreshing()
                
            }
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.businesses == nil {
            return 0
        }
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.businessTableView.dequeueReusableCell(withIdentifier: "businessCell") as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func filtersViewControllerDidUpdate(_ filtersViewController: FiltersViewController) {
        self.fetchData()
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.fetchData()
    }
}
