//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Phuong Thao Tran on 2/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

enum FiltersSection: Int {
    case deals = 0, distance, sort, categories
}

@objc protocol FiltersViewControllerDelegate{
    @objc optional func filtersViewControllerDidUpdate(_ filtersViewController: FiltersViewController)
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    let navigationBarColor = UIColor(red: 21/255, green: 194/255, blue: 179/255, alpha: 1)
    let navigationTitleColor: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
    
    var delegate: FiltersViewControllerDelegate!
    var selectedDeals: Bool = false
    var selectedCategory = [String]()
    var categoryStates = [Int: Bool]()
    var distanceOn = false
    var selectedDistance = maxDistance
    var sortOn = false
    var selectedSort = YelpSortMode.bestMatched
    
    fileprivate func yelpDistances() -> [[String:AnyObject]] {
        let milesPerMeter = 1/0.000621371
        return [["name": "Auto" as AnyObject, "meters" : maxDistance as AnyObject],
                ["name": "0.3 miles" as AnyObject, "meters" : 0.3 * milesPerMeter as AnyObject],
                ["name": "1 mile" as AnyObject, "meters" : 1 * milesPerMeter as AnyObject],
                ["name": "5 miles" as AnyObject, "meters" : 5 * milesPerMeter as AnyObject],
                ["name": "20 miles" as AnyObject, "meters" : 20 * milesPerMeter as AnyObject]]
    }
    var distances: [[String:AnyObject]]!
    
    fileprivate func yelpSorts() -> [[String:AnyObject]] {
        return [["name": "Best Matched" as AnyObject, "sort": YelpSortMode.bestMatched as AnyObject],
                ["name": "Distance" as AnyObject, "sort": YelpSortMode.distance as AnyObject],
                ["name": "Highest Rated" as AnyObject, "sort": YelpSortMode.highestRated as AnyObject]]
    }
    var sorts: [[String:AnyObject]]!
    
    let categories: [[String: String]] =
        [["name" : "Afghan", "code": "afghani"],
         ["name" : "African", "code": "african"],
         ["name" : "American, New", "code": "newamerican"],
         ["name" : "American, Traditional", "code": "tradamerican"],
         ["name" : "Arabian", "code": "arabian"],
         ["name" : "Argentine", "code": "argentine"],
         ["name" : "Armenian", "code": "armenian"],
         ["name" : "Asian Fusion", "code": "asianfusion"],
         ["name" : "Asturian", "code": "asturian"],
         ["name" : "Australian", "code": "australian"],
         ["name" : "Austrian", "code": "austrian"],
         ["name" : "Baguettes", "code": "baguettes"],
         ["name" : "Bangladeshi", "code": "bangladeshi"],
         ["name" : "Barbeque", "code": "bbq"],
         ["name" : "Basque", "code": "basque"],
         ["name" : "Bavarian", "code": "bavarian"],
         ["name" : "Beer Garden", "code": "beergarden"],
         ["name" : "Beer Hall", "code": "beerhall"],
         ["name" : "Beisl", "code": "beisl"],
         ["name" : "Belgian", "code": "belgian"],
         ["name" : "Bistros", "code": "bistros"],
         ["name" : "Black Sea", "code": "blacksea"],
         ["name" : "Brasseries", "code": "brasseries"],
         ["name" : "Brazilian", "code": "brazilian"],
         ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
         ["name" : "British", "code": "british"],
         ["name" : "Buffets", "code": "buffets"],
         ["name" : "Bulgarian", "code": "bulgarian"],
         ["name" : "Burgers", "code": "burgers"],
         ["name" : "Burmese", "code": "burmese"],
         ["name" : "Cafes", "code": "cafes"],
         ["name" : "Cafeteria", "code": "cafeteria"],
         ["name" : "Cajun/Creole", "code": "cajun"],
         ["name" : "Cambodian", "code": "cambodian"],
         ["name" : "Canadian", "code": "New)"],
         ["name" : "Canteen", "code": "canteen"],
         ["name" : "Caribbean", "code": "caribbean"],
         ["name" : "Catalan", "code": "catalan"],
         ["name" : "Chech", "code": "chech"],
         ["name" : "Cheesesteaks", "code": "cheesesteaks"],
         ["name" : "Chicken Shop", "code": "chickenshop"],
         ["name" : "Chicken Wings", "code": "chicken_wings"],
         ["name" : "Chilean", "code": "chilean"],
         ["name" : "Chinese", "code": "chinese"],
         ["name" : "Comfort Food", "code": "comfortfood"],
         ["name" : "Corsican", "code": "corsican"],
         ["name" : "Creperies", "code": "creperies"],
         ["name" : "Cuban", "code": "cuban"],
         ["name" : "Curry Sausage", "code": "currysausage"],
         ["name" : "Cypriot", "code": "cypriot"],
         ["name" : "Czech", "code": "czech"],
         ["name" : "Czech/Slovakian", "code": "czechslovakian"],
         ["name" : "Danish", "code": "danish"],
         ["name" : "Delis", "code": "delis"],
         ["name" : "Diners", "code": "diners"],
         ["name" : "Dumplings", "code": "dumplings"],
         ["name" : "Eastern European", "code": "eastern_european"],
         ["name" : "Ethiopian", "code": "ethiopian"],
         ["name" : "Fast Food", "code": "hotdogs"],
         ["name" : "Filipino", "code": "filipino"],
         ["name" : "Fish & Chips", "code": "fishnchips"],
         ["name" : "Fondue", "code": "fondue"],
         ["name" : "Food Court", "code": "food_court"],
         ["name" : "Food Stands", "code": "foodstands"],
         ["name" : "French", "code": "french"],
         ["name" : "French Southwest", "code": "sud_ouest"],
         ["name" : "Galician", "code": "galician"],
         ["name" : "Gastropubs", "code": "gastropubs"],
         ["name" : "Georgian", "code": "georgian"],
         ["name" : "German", "code": "german"],
         ["name" : "Giblets", "code": "giblets"],
         ["name" : "Gluten-Free", "code": "gluten_free"],
         ["name" : "Greek", "code": "greek"],
         ["name" : "Halal", "code": "halal"],
         ["name" : "Hawaiian", "code": "hawaiian"],
         ["name" : "Heuriger", "code": "heuriger"],
         ["name" : "Himalayan/Nepalese", "code": "himalayan"],
         ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
         ["name" : "Hot Dogs", "code": "hotdog"],
         ["name" : "Hot Pot", "code": "hotpot"],
         ["name" : "Hungarian", "code": "hungarian"],
         ["name" : "Iberian", "code": "iberian"],
         ["name" : "Indian", "code": "indpak"],
         ["name" : "Indonesian", "code": "indonesian"],
         ["name" : "International", "code": "international"],
         ["name" : "Irish", "code": "irish"],
         ["name" : "Island Pub", "code": "island_pub"],
         ["name" : "Israeli", "code": "israeli"],
         ["name" : "Italian", "code": "italian"],
         ["name" : "Japanese", "code": "japanese"],
         ["name" : "Jewish", "code": "jewish"],
         ["name" : "Kebab", "code": "kebab"],
         ["name" : "Korean", "code": "korean"],
         ["name" : "Kosher", "code": "kosher"],
         ["name" : "Kurdish", "code": "kurdish"],
         ["name" : "Laos", "code": "laos"],
         ["name" : "Laotian", "code": "laotian"],
         ["name" : "Latin American", "code": "latin"],
         ["name" : "Live/Raw Food", "code": "raw_food"],
         ["name" : "Lyonnais", "code": "lyonnais"],
         ["name" : "Malaysian", "code": "malaysian"],
         ["name" : "Meatballs", "code": "meatballs"],
         ["name" : "Mediterranean", "code": "mediterranean"],
         ["name" : "Mexican", "code": "mexican"],
         ["name" : "Middle Eastern", "code": "mideastern"],
         ["name" : "Milk Bars", "code": "milkbars"],
         ["name" : "Modern Australian", "code": "modern_australian"],
         ["name" : "Modern European", "code": "modern_european"],
         ["name" : "Mongolian", "code": "mongolian"],
         ["name" : "Moroccan", "code": "moroccan"],
         ["name" : "New Zealand", "code": "newzealand"],
         ["name" : "Night Food", "code": "nightfood"],
         ["name" : "Norcinerie", "code": "norcinerie"],
         ["name" : "Open Sandwiches", "code": "opensandwiches"],
         ["name" : "Oriental", "code": "oriental"],
         ["name" : "Pakistani", "code": "pakistani"],
         ["name" : "Parent Cafes", "code": "eltern_cafes"],
         ["name" : "Parma", "code": "parma"],
         ["name" : "Persian/Iranian", "code": "persian"],
         ["name" : "Peruvian", "code": "peruvian"],
         ["name" : "Pita", "code": "pita"],
         ["name" : "Pizza", "code": "pizza"],
         ["name" : "Polish", "code": "polish"],
         ["name" : "Portuguese", "code": "portuguese"],
         ["name" : "Potatoes", "code": "potatoes"],
         ["name" : "Poutineries", "code": "poutineries"],
         ["name" : "Pub Food", "code": "pubfood"],
         ["name" : "Rice", "code": "riceshop"],
         ["name" : "Romanian", "code": "romanian"],
         ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
         ["name" : "Rumanian", "code": "rumanian"],
         ["name" : "Russian", "code": "russian"],
         ["name" : "Salad", "code": "salad"],
         ["name" : "Sandwiches", "code": "sandwiches"],
         ["name" : "Scandinavian", "code": "scandinavian"],
         ["name" : "Scottish", "code": "scottish"],
         ["name" : "Seafood", "code": "seafood"],
         ["name" : "Serbo Croatian", "code": "serbocroatian"],
         ["name" : "Signature Cuisine", "code": "signature_cuisine"],
         ["name" : "Singaporean", "code": "singaporean"],
         ["name" : "Slovakian", "code": "slovakian"],
         ["name" : "Soul Food", "code": "soulfood"],
         ["name" : "Soup", "code": "soup"],
         ["name" : "Southern", "code": "southern"],
         ["name" : "Spanish", "code": "spanish"],
         ["name" : "Steakhouses", "code": "steak"],
         ["name" : "Sushi Bars", "code": "sushi"],
         ["name" : "Swabian", "code": "swabian"],
         ["name" : "Swedish", "code": "swedish"],
         ["name" : "Swiss Food", "code": "swissfood"],
         ["name" : "Tabernas", "code": "tabernas"],
         ["name" : "Taiwanese", "code": "taiwanese"],
         ["name" : "Tapas Bars", "code": "tapas"],
         ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
         ["name" : "Tex-Mex", "code": "tex-mex"],
         ["name" : "Thai", "code": "thai"],
         ["name" : "Traditional Norwegian", "code": "norwegian"],
         ["name" : "Traditional Swedish", "code": "traditional_swedish"],
         ["name" : "Trattorie", "code": "trattorie"],
         ["name" : "Turkish", "code": "turkish"],
         ["name" : "Ukrainian", "code": "ukrainian"],
         ["name" : "Uzbek", "code": "uzbek"],
         ["name" : "Vegan", "code": "vegan"],
         ["name" : "Vegetarian", "code": "vegetarian"],
         ["name" : "Venison", "code": "venison"],
         ["name" : "Vietnamese", "code": "vietnamese"],
         ["name" : "Wok", "code": "wok"],
         ["name" : "Wraps", "code": "wraps"],
         ["name" : "Yugoslav", "code": "yugoslav"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = navigationBarColor
        
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleColor as? [String : Any]
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
        distances = yelpDistances()
        sorts = yelpSorts()
        
        selectedDistance = BusinessFilterSettings.sharedIntance.distance ?? maxDistance
        distanceOn = selectedDistance != maxDistance
        
        selectedSort = BusinessFilterSettings.sharedIntance.sort ?? YelpSortMode.bestMatched
        sortOn = selectedSort != YelpSortMode.bestMatched
        
        selectedDeals = BusinessFilterSettings.sharedIntance.deals ?? false
        selectedCategory = BusinessFilterSettings.sharedIntance.categories
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch FiltersSection(rawValue: section)! {
        case FiltersSection.deals:
            return 1
        case FiltersSection.distance:
            return distanceOn ? distances.count + 1 : 1
        case FiltersSection.sort:
            return sortOn ? sorts.count + 1 : 1
        default:
            return categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var headerText: String
        switch FiltersSection(rawValue: section)! {
        case FiltersSection.deals:
            headerText = "Deals"
        case FiltersSection.distance:
            headerText = "Distance"
        case FiltersSection.sort:
            headerText = "Sort By"
        default:
            headerText = "Category"
        }
        return headerText
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch FiltersSection(rawValue: indexPath.section)! {
        case FiltersSection.deals:
            let cell = filterTableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = "Offering a Deal"
            cell.switchSwitch.isOn = BusinessFilterSettings.sharedIntance.deals ?? false
            cell.delegate = self
            return cell
        case FiltersSection.distance:
            if (indexPath as NSIndexPath).row == 0 {
                let cell = filterTableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
                cell.switchLabel.text = "Filter by Distance"
                cell.switchSwitch.isOn = distanceOn
                cell.delegate = self
                return cell
            }
            else {
                let cell = filterTableView.dequeueReusableCell(withIdentifier: "expandCell", for: indexPath) as! ExpandCell
                let distance = distances[(indexPath as NSIndexPath).row - 1]
                cell.expandLabel.text = distance["name"] as! String?
                if (distance["meters"] as! Double != selectedDistance) {
                    cell.accessoryType = .none
                }
                else {
                    cell.accessoryType = .checkmark
                }
                return cell
            }
        case FiltersSection.sort:
            if (indexPath as NSIndexPath).row == 0 {
                let cell = filterTableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
                cell.switchLabel.text = "Sort By"
                cell.switchSwitch.isOn = sortOn
                cell.delegate = self
                return cell
            } else {
                let cell = filterTableView.dequeueReusableCell(withIdentifier: "expandCell", for: indexPath) as! ExpandCell
                let sort = sorts[(indexPath as NSIndexPath).row - 1]
                cell.expandLabel.text = sort["name"] as! String?
                if (sort["sort"] as! YelpSortMode != selectedSort) {
                    cell.accessoryType = .none
                }
                else {
                    cell.accessoryType = .checkmark
                }
                return cell
            }
        default:
            let cell = filterTableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = categories[indexPath.row]["name"]
            if BusinessFilterSettings.sharedIntance.categories.contains(categories[indexPath.row]["code"]!) {
                cell.switchSwitch.isOn = true
            }
            else {
                cell.switchSwitch.isOn = categoryStates[indexPath.row] ?? false
            }
            
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterTableView.deselectRow(at: indexPath, animated: true)
        
        let cell = self.tableView(filterTableView, cellForRowAt: indexPath)
        if "expandCell" == cell.reuseIdentifier {
            switch FiltersSection(rawValue: indexPath.section)! {
            case FiltersSection.distance:
                if (indexPath as NSIndexPath).row != 0 {
                    selectedDistance = distances[(indexPath as NSIndexPath).row - 1]["meters"] as! Double
                    filterTableView.reloadSections(IndexSet(integer: 1), with: .none)
                }
                filterTableView.reloadSections(NSIndexSet(index: FiltersSection.distance.rawValue) as IndexSet, with: .none)
            case FiltersSection.sort:
                if (indexPath as NSIndexPath).row != 0 {
                    selectedSort = sorts[(indexPath as NSIndexPath).row - 1]["sort"] as! YelpSortMode
                    filterTableView.reloadSections(IndexSet(integer: 1), with: .none)
                }
                filterTableView.reloadSections(NSIndexSet(index: FiltersSection.sort.rawValue) as IndexSet, with: .none)
            default:
                break
                
            }
        }
    }
    
    func switchCell(switchCell: SwitchCell, didValueChanged value: Bool) {
        let index = filterTableView.indexPath(for: switchCell)
        
        switch FiltersSection(rawValue: index!.section)! {
        case FiltersSection.deals:
            selectedDeals = value
        case FiltersSection.distance:
            distanceOn = switchCell.switchSwitch.isOn
            if selectedDistance == maxDistance {
                selectedDistance = distances[0]["meters"] as! Double
            }
            filterTableView.reloadSections(NSIndexSet(index: FiltersSection.distance.rawValue) as IndexSet, with: .none)
        case FiltersSection.sort:
            sortOn = switchCell.switchSwitch.isOn
            if selectedSort == YelpSortMode.bestMatched {
                selectedSort = sorts[0]["sort"] as! YelpSortMode
            }
            filterTableView.reloadSections(NSIndexSet(index: FiltersSection.sort.rawValue) as IndexSet, with: .none)
        default:
            categoryStates[index!.row] = value
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        BusinessFilterSettings.sharedIntance.deals = selectedDeals
        BusinessFilterSettings.sharedIntance.distance = distanceOn ? selectedDistance : maxDistance
        BusinessFilterSettings.sharedIntance.sort = sortOn ? selectedSort : YelpSortMode.bestMatched
        
        for (row, isSelected) in categoryStates {
            if isSelected {
                selectedCategory.append(categories[row]["code"]!)
            }
            else {
                if let index = selectedCategory.index(of: categories[row]["code"]!) {
                    selectedCategory.remove(at: index)
                }
            }
        }
        
        if selectedCategory.count > 0 {
            BusinessFilterSettings.sharedIntance.categories = selectedCategory
        }
        
        delegate?.filtersViewControllerDidUpdate?(self)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
