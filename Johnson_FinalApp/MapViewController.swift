//
//  MapViewController.swift
//  Johnson_FinalApp
//
//  Created by DJ on 4/19/19.
//  Copyright © 2019 DJ. All rights reserved.
//
//  Author: Donald Johnson
//  Purpose: Implement the functionality of the map view

import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {
    //Link the map view
    @IBOutlet weak var mapView: MKMapView!
    //Segue input variables
    var origin: String!
    var fName: String!
    var lName: String!
    //Arrays to store Philosopher objects
    var philosopherObjects = [Philosophers]()
    var searchResults = [Philosophers]()
    //Variable to track search status
    var searchActive = false
    //Handle the text changing in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = philosopherObjects.filter({$0.firstName.lowercased().prefix(searchText.count)  == searchText.lowercased() || $0.lastName.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searchActive = true
    }
    //Handle the search bar being clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let annotations = self.mapView.annotations
        mapView.removeAnnotations(annotations)
        addAnnotation()
    }
    //Handle the cancel button on the search bar being clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        readPropertyList()
        addAnnotation()
    }
    //Read the property list filtered based on whether segue data has been passed in
    func readPropertyList(){
        let path = Bundle.main.path(forResource: "Philosophers", ofType: "plist")!
        
        let philopherArray:NSArray = NSArray(contentsOfFile: path)!
        
        
        for item in philopherArray{
            let dictionary: [String:Any] = (item as? Dictionary)!
            
            if (origin != nil){
                if ((dictionary["firstName"] as! String) == fName && (dictionary["lastName"] as! String) == lName){
                    if (dictionary["firstName"] as! String == dictionary["lastName"] as! String){
                        philosopherObjects.append(Philosophers(origin: origin, firstName: dictionary["firstName"] as! String, lastName: dictionary["firstName"] as! String, cellImage: (dictionary["cellImage"] as! String)))
                    }
                    else{
                        philosopherObjects.append(Philosophers(origin: origin, firstName: dictionary["firstName"] as! String, lastName: dictionary["lastName"] as! String, cellImage: (dictionary["cellImage"] as! String)))
                    }
                }
            }
            else {
                if ((dictionary["firstName"] as! String) == (dictionary["lastName"] as! String)){
                    philosopherObjects.append(Philosophers(origin: dictionary["origin"] as! String, firstName: dictionary["firstName"] as! String, lastName: dictionary["firstName"] as! String, cellImage: (dictionary["cellImage"] as! String)))
                }
                else{
                    philosopherObjects.append(Philosophers(origin: dictionary["origin"] as! String, firstName: dictionary["firstName"] as! String, lastName: dictionary["lastName"] as! String, cellImage: (dictionary["cellImage"] as! String)))
                }
            }
        }
    }
    //Add map annotations filtered based on whether the search is active
    func addAnnotation(){
        if (searchActive){
            for item in searchResults{
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = item.origin
                let searchProcess = MKLocalSearch(request: searchRequest)
                searchProcess.start{(response, error) in UIApplication.shared.endIgnoringInteractionEvents()
                    if (response == nil){
                        print("Did not find location")
                    }
                    else {
                        let latitude = response?.boundingRegion.center.latitude
                        let longitude = response?.boundingRegion.center.longitude
                        
                        let locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                        let annotation = MKPointAnnotation()
                        if (item.firstName == item.lastName){
                            annotation.title = item.firstName
                        }
                        else {
                            annotation.title = item.firstName + " " + item.lastName
                        }
                        annotation.subtitle = item.origin
                        annotation.coordinate = locationCoordinate
                        if (self.origin != nil){
                            let mapRegion = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 8000, longitudinalMeters: 8000)
                            self.mapView.setRegion(mapRegion, animated: true)
                        }
                        else{
                            let defaultC: CLLocationCoordinate2D = CLLocationCoordinate2DMake(27.926474, -38.528603)
                            let mapRegion = MKCoordinateRegion(center: defaultC, latitudinalMeters: 10000000, longitudinalMeters: 10000000)
                            self.mapView.setRegion(mapRegion, animated: true)
                        }
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        }
        else {
            for item in philosopherObjects{
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = item.origin
                let searchProcess = MKLocalSearch(request: searchRequest)
                searchProcess.start{(response, error) in UIApplication.shared.endIgnoringInteractionEvents()
                    if (response == nil){
                        print("Did not find location")
                    }
                    else {
                        let latitude = response?.boundingRegion.center.latitude
                        let longitude = response?.boundingRegion.center.longitude
                        
                        let locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                        let annotation = MKPointAnnotation()
                        if (item.firstName == item.lastName){
                            annotation.title = item.firstName
                        }
                        else {
                            annotation.title = item.firstName + " " + item.lastName
                        }
                        annotation.subtitle = item.origin
                        annotation.coordinate = locationCoordinate
                        if (self.origin != nil){
                            let mapRegion = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 8000, longitudinalMeters: 8000)
                            self.mapView.setRegion(mapRegion, animated: true)
                        }
                        else{
                            let defaultC: CLLocationCoordinate2D = CLLocationCoordinate2DMake(27.926474, -38.528603)
                            let mapRegion = MKCoordinateRegion(center: defaultC, latitudinalMeters: 10000000, longitudinalMeters: 10000000)
                            self.mapView.setRegion(mapRegion, animated: true)
                        }
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate{
    //Populate the view for the annotations filtered based on whether the search is active
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if (annotationView == nil){
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        annotationView?.canShowCallout = true
        
        if (searchActive){
            for item in searchResults{
                if (item.firstName == item.lastName){
                    if (item.firstName  == annotation.title){
                        let request = URLRequest(url: URL(string: item.cellImage)!)
                        let task = URLSession.shared.dataTask(with: request as URLRequest) {imageData,response,error in
                            if let downloadImage = imageData {
                                if let dImage = UIImage(data: downloadImage)
                                {
                                    DispatchQueue.main.async {
                                        let pinImage = dImage
                                        var size = CGSize()
                                        if (self.origin == nil){
                                            size = CGSize(width: 35, height: 35)
                                        }
                                        else {
                                            size = CGSize(width: 80, height: 80)
                                        }
                                        
                                        UIGraphicsBeginImageContext(size)
                                        pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                                        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                                        annotationView?.image = resizedImage
                                        
                                        let btn = UIButton(type: .detailDisclosure)
                                        annotationView?.rightCalloutAccessoryView = btn
                                    }
                                }
                            }
                        }
                        task.resume()
                    }
                }
                else if ((item.firstName + " " + item.lastName) == annotation.title){
                    let request = URLRequest(url: URL(string: item.cellImage)!)
                    let task = URLSession.shared.dataTask(with: request as URLRequest) {imageData,response,error in
                        if let downloadImage = imageData {
                            if let dImage = UIImage(data: downloadImage)
                            {
                                DispatchQueue.main.async {
                                    let pinImage = dImage
                                    var size = CGSize()
                                    if (self.origin == nil){
                                        size = CGSize(width: 35, height: 35)
                                    }
                                    else {
                                        size = CGSize(width: 80, height: 80)
                                    }
                                    
                                    UIGraphicsBeginImageContext(size)
                                    pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                                    annotationView?.image = resizedImage
                                    
                                    let btn = UIButton(type: .detailDisclosure)
                                    annotationView?.rightCalloutAccessoryView = btn
                                }
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
        else {
            for item in philosopherObjects{
                if (item.firstName == item.lastName){
                    if (item.firstName  == annotation.title){
                        let request = URLRequest(url: URL(string: item.cellImage)!)
                        let task = URLSession.shared.dataTask(with: request as URLRequest) {imageData,response,error in
                            if let downloadImage = imageData {
                                if let dImage = UIImage(data: downloadImage)
                                {
                                    DispatchQueue.main.async {
                                        let pinImage = dImage
                                        var size = CGSize()
                                        if (self.origin == nil){
                                            size = CGSize(width: 35, height: 35)
                                        }
                                        else {
                                            size = CGSize(width: 80, height: 80)
                                        }
                                        
                                        UIGraphicsBeginImageContext(size)
                                        pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                                        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                                        annotationView?.image = resizedImage
                                        
                                        let btn = UIButton(type: .detailDisclosure)
                                        annotationView?.rightCalloutAccessoryView = btn
                                    }
                                }
                            }
                        }
                        task.resume()
                    }
                }
                else if ((item.firstName + " " + item.lastName) == annotation.title){
                    let request = URLRequest(url: URL(string: item.cellImage)!)
                    let task = URLSession.shared.dataTask(with: request as URLRequest) {imageData,response,error in
                        if let downloadImage = imageData {
                            if let dImage = UIImage(data: downloadImage)
                            {
                                DispatchQueue.main.async {
                                    let pinImage = dImage
                                    var size = CGSize()
                                    if (self.origin == nil){
                                        size = CGSize(width: 35, height: 35)
                                    }
                                    else {
                                        size = CGSize(width: 80, height: 80)
                                    }
                                    
                                    UIGraphicsBeginImageContext(size)
                                    pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                                    annotationView?.image = resizedImage
                                    
                                    let btn = UIButton(type: .detailDisclosure)
                                    annotationView?.rightCalloutAccessoryView = btn
                                }
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
        return annotationView
    }
    //Handle the annotation being selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pinImage = view.image
        var size = CGSize()
        if (self.origin == nil){
            size = CGSize(width: 50, height: 50)
        }
        else {
            size = CGSize(width: 80, height: 80)
        }
        
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        view.image = resizedImage
    }
    //Handle the annotation being deselected
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let pinImage = view.image
        var size = CGSize()
        if (self.origin == nil){
            size = CGSize(width: 35, height: 35)
        }
        else {
            size = CGSize(width: 80, height: 80)
        }
        
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        view.image = resizedImage
    }
    //Segue to the PhilosophersViewController if the accessory control of the annotation view is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "PhilosophersViewController") as! PhilosophersViewController
        
        for item in philosopherObjects{
            if (item.lastName == item.firstName){
                if (item.firstName == view.annotation?.title){
                    destVC.firstName = item.firstName
                    destVC.lastName = item.firstName
                    self.navigationController?.pushViewController(destVC, animated: true)
                }
            }
            else if ((item.firstName + " " + item.lastName) == view.annotation?.title){
                destVC.firstName = item.firstName
                destVC.lastName = item.lastName
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        }
    }
}
