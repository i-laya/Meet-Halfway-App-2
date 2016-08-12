//
//  LocationSearchTable.swift
//  Meet-Halfway
//
//  Created by Laya Indukuri on 8/1/16.
//  Copyright © 2016 Make School. All rights reserved.
//


import UIKit
import MapKit
import Contacts
import AddressBookUI

class LocationSearchTable : UITableViewController {
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }

}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {

        let searchBarText = searchController.searchBar.text
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    

}

extension LocationSearchTable {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedItem = matchingItems[indexPath.row]
        
        SearchHelper.storedGeneralAddress = selectedItem

        let address = ABCreateStringWithAddressDictionary(selectedItem.placemark.addressDictionary!, false)
        
        SearchHelper.placeAddress = address
        NSNotificationCenter.defaultCenter().postNotificationName("update_input", object: nil)
        
        print(address)
        
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        print(NSUserDefaults.standardUserDefaults().objectForKey("address1"))
    }
}











