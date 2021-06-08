//
//  BranchesDetailViewController.swift
//  Johnson_FinalApp
//
//  Copyright © 2019 DJ. All rights reserved.
//
//  Author: Donald Johnson
//  Purpose: Implement the functionality of the Branches detail view controller

import UIKit

class BranchesDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    //Link view components
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var philosophersLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    //Segue input variables
    var branch: String!
    var information: String!
    var wiki: String!
    var sep: String!
    //Array to store Philosopher objects
    var philosopherObjects = [Philosophers]()
    //Read property list and store data in philosopherObjects
    func readPropertyList(){
        let path = Bundle.main.path(forResource: "Philosophers", ofType: "plist")!
        
        let philopherArray:NSArray = NSArray(contentsOfFile: path)!
        
        for item in philopherArray{
            let dictionary: [String:Any] = (item as? Dictionary)!
            
            for (b, value) in dictionary {
                if (b == branch){
                    if (value as! Bool == true){
                        let image = dictionary["cellImage"]
                        let firstName = dictionary["firstName"]
                        let lastName = dictionary["lastName"]
                        
                        philosopherObjects.append(Philosophers(firstName: firstName as! String, lastName: lastName as! String, cellImage: image as! String))
                    }
                }
            }
        }
    }
    //Handle the search button being clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "PhilosophersCollectionViewController") as! PhilosophersCollectionViewController
        destVC.sentSearch = searchBar.text
        self.navigationController?.pushViewController(destVC, animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        readPropertyList()
        //Sort philosophers by last name
        philosopherObjects = philosopherObjects.sorted(by: {$0.lastName < $1.lastName})
        collectionView.reloadData()
        label.text = branch
        info.text = information
        philosophersLabel.text = "Philosophers of " + branch
    }
    //Return number of philosopher objects for number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return philosopherObjects.count
    }
    //Populate collection view cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BRANCHCELL", for: indexPath) as! BranchesCollectionViewCell
        
        if(philosopherObjects[indexPath.row].firstName == philosopherObjects[indexPath.row].lastName){
            cell.cellLabel.text = philosopherObjects[indexPath.row].firstName
        }
        else{
            cell.cellLabel.text = philosopherObjects[indexPath.row].firstName + " " + philosopherObjects[indexPath.row].lastName
        }
        displayImage(imageURL: URL(string: philosopherObjects[indexPath.row].cellImage)!, cell: cell)
        
        return cell
    }
    //Instantiates a URL session to display an image from the given URL on the given cell
    func displayImage(imageURL: URL, cell: BranchesCollectionViewCell){
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
        destVC.firstName = philosopherObjects[indexPath.row].firstName
        destVC.lastName = philosopherObjects[indexPath.row].lastName
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    //Segue to the appropriate view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "BRANCHWIKISHOW"){
            let destVC = segue.destination as! WebViewController
            destVC.navigationItem.backBarButtonItem?.title = branch
            destVC.www = wiki
        }
        else if (segue.identifier == "BRANCHSEPSHOW"){
            let destVC = segue.destination as! WebViewController
            navigationItem.backBarButtonItem?.title = branch
            destVC.www = sep
        }
    }

}
