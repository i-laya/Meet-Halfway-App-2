//
//  InputViewController.swift
//  Meet-Halfway
//
//  Created by Laya Indukuri on 7/27/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import MapKit


class InputViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func restaurantsButton(sender: UIButton) {
        YelpHelper.category = "restaurants"
    }
   
    @IBAction func artsButton(sender: UIButton) {
        YelpHelper.category = "arts"
    }
    
    @IBAction func activeButton(sender: UIButton) {
        YelpHelper.category = "active"
    }
    
    
    @IBAction func mapButton(sender: AnyObject) {
        
        if (SearchHelper.storedAddress1 == nil || SearchHelper.storedAddress2 == nil){
            
            let alertView = UIAlertController(title: "Alert", message: "Please enter both addresses", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
            alertView.addAction(cancelAction)
            
            self.presentViewController(alertView, animated: true, completion: nil)

        }
        else {
            self.performSegueWithIdentifier("showMap", sender: self)
        }
        
    }
    
        
    var resultSearchController:UISearchController? = nil
    
    //Search Bar stuff
    var locationSearchTable: LocationSearchTable?

    var selectedPin:MKPlacemark? = nil
    
    var placeAddress1 = "select address 1"
    var placeAddress2 = "select address 2"
    
    var firstAddressField: Bool = false
    var secondAddressField: Bool = false
    
    
    //first address field
    @IBAction func firstButtonClicked(sender: AnyObject) {
        navigationItem.titleView = resultSearchController?.searchBar
        self.resultSearchController?.searchBar.becomeFirstResponder()
        resultSearchController?.searchBar.hidden = false
        firstAddressField = true
    }
    
    //second address field
    @IBAction func secondButtonClicked(sender: AnyObject) {
        navigationItem.titleView = resultSearchController?.searchBar
        self.resultSearchController?.searchBar.becomeFirstResponder()
        resultSearchController?.searchBar.hidden = false
        secondAddressField = true
    }

    @IBOutlet weak var address1Field: UIButton!
    
    @IBOutlet weak var address2Field: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        //Search Bar stuff
        locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as? LocationSearchTable
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        //Search Bar stuff
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable!.mapView = mapView

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(configureView), name: "update_input", object: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        
    }
    
    func configureView() {
        resultSearchController?.searchBar.hidden = true
        
        if firstAddressField == true {
            address1Field.setTitle(SearchHelper.placeAddress, forState: .Normal)
            placeAddress1 = SearchHelper.placeAddress
            SearchHelper.storedAddress1 = SearchHelper.storedGeneralAddress
            MidpointHelper.assignLatLong1()
        }
        
        if secondAddressField == true {
            address2Field.setTitle(SearchHelper.placeAddress, forState: .Normal)
            placeAddress2 = SearchHelper.placeAddress
            SearchHelper.storedAddress2 = SearchHelper.storedGeneralAddress
            MidpointHelper.assignLatLong2()
        }
        
        if LocationSearchTable().searchDisplayController?.active == false {
            resultSearchController?.searchBar.hidden = true
        }
        
        firstAddressField = false
        secondAddressField = false
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        resultSearchController?.searchBar.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension InputViewController: UISearchControllerDelegate {
    func didDismissSearchController(searchController: UISearchController){
        locationSearchTable!.matchingItems = []
        locationSearchTable!.tableView.reloadData()
    }
}
