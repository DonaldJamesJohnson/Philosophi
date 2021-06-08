//
//  PhilosophersCollectionViewController.swift
//  Johnson_FinalApp
//
//  Copyright © 2019 DJ. All rights reserved.
//
//  Author: Donald Johnson
//  Purpose: Implement the functionality of the Philosophers Collection View Controller

import UIKit

class PhilosophersCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    //Segue input variables
    var fName: String!
    var lName: String!
    var bDate: String!
    var alpha = true
    var searchActive = false
    var sentSearch: String!
    //Segment control function
    @IBAction func cellSort(_ sender: Any) {
        alpha = !alpha
        searchActive = false
        collectionView.reloadData()
    }
    //Link the collection view
    @IBOutlet weak var collectionView: UICollectionView!
    //Outlets for the view components
    @IBAction func sortBar(_ sender: Any) {
    }
    @IBOutlet weak var sortBarOut: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    //Variables to store philosopher objects
    var philosopherObjects = [Philosophers]()
    var alphaSort = [Philosophers]()
    var chronoSort = [Philosophers]()
    var searchResults = [Philosophers]()
    //Read the property list and store the philosopher objects in the philosopherObjects array
    func readPropertyList(){
        let path = Bundle.main.path(forResource: "Philosophers", ofType: "plist")!
        
        let philopherArray:NSArray = NSArray(contentsOfFile: path)!
        
        for item in philopherArray{
            let dictionary: [String:Any] = (item as? Dictionary)!
            if (fName != nil){
                if ((dictionary["firstName"] as! String) == fName && (dictionary["lastName"] as! String) == lName){
                    let image = dictionary["cellImage"]
                    let firstName = dictionary["firstName"]
                    let lastName = dictionary["lastName"]
                    let birthDate = dictionary["birthDate"]
                    let deathDate = dictionary["deathDate"]
                    
                    philosopherObjects.append(Philosophers(firstName: firstName as! String, lastName: lastName as! String, birthDate: birthDate as! String, deathDate: deathDate as! String, cellImage: image as! String))
                }
            }
            else{
                let image = dictionary["cellImage"]
                let firstName = dictionary["firstName"]
                let lastName = dictionary["lastName"]
                let birthDate = dictionary["birthDate"]
                let deathDate = dictionary["deathDate"]
                
                philosopherObjects.append(Philosophers(firstName: firstName as! String, lastName: lastName as! String, birthDate: birthDate as! String, deathDate: deathDate as! String, cellImage: image as! String))
            }
        }
    }
    //Handle the text changing in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = philosopherObjects.filter({$0.firstName.lowercased().prefix(searchText.count)  == searchText.lowercased() || $0.lastName.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searchResults = searchResults.sorted(by:{$0.lastName < $1.lastName})
        searchActive = true
        collectionView.reloadData()
    }
    //Handle the cancel button on the search bar being clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = nil
        collectionView.reloadData()
        sortBarOut.isHidden = false
        sortBarOut.isEnabled = true
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readPropertyList()
        //Check to see if a search has been sent from another view
        if (sentSearch != nil){
            searchResults = philosopherObjects.filter({$0.firstName.lowercased().prefix(sentSearch.count)  == sentSearch.lowercased() || $0.lastName.lowercased().prefix(sentSearch.count) == sentSearch.lowercased()})
            searchActive = true
            collectionView.reloadData()
        }
        else{
            alphaSort = philosopherObjects.sorted(by: {$0.lastName < $1.lastName})
            chronoSort = philosopherObjects.sorted(by: {($0.birthDate as NSString).integerValue < ($1.birthDate as NSString).integerValue})
        }
        //Check to see if the user is currently searching
        if (searchActive){
            sortBarOut.isHidden = true
            sortBarOut.isEnabled = false
        }
    }
    //Return the number of items based on whether the search is active
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (searchActive){
            return searchResults.count
        }
        else{
            return philosopherObjects.count
        }
    }
    //Populate the collection view cells depending on whether th search is active
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PHILOSOPHERCELL", for: indexPath) as! PhilosopherCollectionViewCell
        
        if (searchActive){
            if (searchResults[indexPath.row].firstName == searchResults[indexPath.row].lastName){
                cell.cellName.text = searchResults[indexPath.row].firstName
            }
            else{
              
                cell.cellName.text = searchResults[indexPath.row].firstName + " " + searchResults[indexPath.row].lastName
            }
            if (searchResults[indexPath.row].birthDate.first == "-"){
                searchResults[indexPath.row].birthDate.remove(at: searchResults[indexPath.row].birthDate.startIndex)
                if (searchResults[indexPath.row].deathDate.first == "-"){
                    searchResults[indexPath.row].deathDate.remove(at: searchResults[indexPath.row].deathDate.startIndex)
                    cell.cellDate.text = searchResults[indexPath.row].birthDate + "-" + searchResults[indexPath.row].deathDate
                }
                else{
                    cell.cellDate.text = searchResults[indexPath.row].birthDate + "-" + searchResults[indexPath.row].deathDate
                }
             }
            else{
                cell.cellDate.text = searchResults[indexPath.row].birthDate + "-" + searchResults[indexPath.row].deathDate
            }
            displayImage(imageURL: URL(string: searchResults[indexPath.row].cellImage)!, cell: cell)
        }
        else{
            if (alpha){
                if (alphaSort[indexPath.row].firstName == alphaSort[indexPath.row].lastName){
                    cell.cellName.text = alphaSort[indexPath.row].firstName
                }
                else{
                    
                    cell.cellName.text = alphaSort[indexPath.row].firstName + " " + alphaSort[indexPath.row].lastName
                }
                if (alphaSort[indexPath.row].birthDate.first == "-"){
                    alphaSort[indexPath.row].birthDate.remove(at: alphaSort[indexPath.row].birthDate.startIndex)
                    if (alphaSort[indexPath.row].deathDate.first == "-"){
                        alphaSort[indexPath.row].deathDate.remove(at: alphaSort[indexPath.row].deathDate.startIndex)
                        cell.cellDate.text = alphaSort[indexPath.row].birthDate + "-" + alphaSort[indexPath.row].deathDate
                    }
                    else{
                        cell.cellDate.text = alphaSort[indexPath.row].birthDate + "-" + alphaSort[indexPath.row].deathDate
                    }
                }
                else{
                    cell.cellDate.text = alphaSort[indexPath.row].birthDate + "-" + alphaSort[indexPath.row].deathDate
                }
                displayImage(imageURL: URL(string: alphaSort[indexPath.row].cellImage)!, cell: cell)
            }
            else{
                if (chronoSort[indexPath.row].firstName == chronoSort[indexPath.row].lastName){
                    cell.cellName.text = chronoSort[indexPath.row].firstName
                }
                else{
                    
                    cell.cellName.text = chronoSort[indexPath.row].firstName + " " + chronoSort[indexPath.row].lastName
                }
                if (chronoSort[indexPath.row].birthDate.first == "-"){
                    chronoSort[indexPath.row].birthDate.remove(at: chronoSort[indexPath.row].birthDate.startIndex)
                    if (chronoSort[indexPath.row].deathDate.first == "-"){
                        chronoSort[indexPath.row].deathDate.remove(at: chronoSort[indexPath.row].deathDate.startIndex)
                        cell.cellDate.text = chronoSort[indexPath.row].birthDate + "-" + chronoSort[indexPath.row].deathDate
                    }
                    else{
                        cell.cellDate.text = chronoSort[indexPath.row].birthDate + "-" + chronoSort[indexPath.row].deathDate
                    }
                }
                else{
                    cell.cellDate.text = chronoSort[indexPath.row].birthDate + "-" + chronoSort[indexPath.row].deathDate
                }
                displayImage(imageURL: URL(string: chronoSort[indexPath.row].cellImage)!, cell: cell)
            }
            
        }
        return cell
    }
    //Instantiates a URL session to display an image from the given URL on the given cell
    func displayImage(imageURL: URL, cell: PhilosopherCollectionViewCell){
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: imageURL, completionHandler: {
            (imageData, response, error) in
            if let downloadImage = imageData {
                if let dImage = UIImage(data: downloadImage)
                {
                    DispatchQueue.main.async {
                        cell.cellImage.image = dImage
                    }
                }
            }
        }).resume()
    }
    //If user selects a cell, send appropriate data and transfer view to PhilosophersViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "PhilosophersViewController") as! PhilosophersViewController
        if (searchActive){
            destVC.firstName = searchResults[indexPath.row].firstName
            destVC.lastName = searchResults[indexPath.row].lastName
            self.navigationController?.pushViewController(destVC, animated: true)
        }
        else{
            if (alpha){
                destVC.firstName = alphaSort[indexPath.row].firstName
                destVC.lastName = alphaSort[indexPath.row].lastName
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else{
                destVC.firstName = chronoSort[indexPath.row].firstName
                destVC.lastName = chronoSort[indexPath.row].lastName
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        }
    }
}
