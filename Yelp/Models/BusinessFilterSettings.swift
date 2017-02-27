//
//  BusinessFilterSettings.swift
//  Yelp
//
//  Created by Phuong Thao Tran on 2/27/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

let maxDistance: Double = 40000

class BusinessFilterSettings {
    var keyword: String?
    var sort: YelpSortMode!
    var categories = [String]()
    var deals: Bool?
    
    var limit: Int?
    var offset: Int?
    var distance: Double!
    
    static let sharedIntance = BusinessFilterSettings()
}
