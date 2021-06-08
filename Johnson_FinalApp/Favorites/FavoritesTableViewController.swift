//
//  FavoritesTableViewController.swift
//  Johnson_FinalApp
//
//  Copyright © 2019 DJ. All rights reserved.
//
//  Author: Donald Johnson
//  Purpose: Implement the functionality of the FavoritesTableView

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    //Link the table view
    @IBOutlet var favoriteView: UITableView!
    
    var people: [NSManagedObject] = []  //Variable to store core data objects
    var philosopherObjects = [Philosophers]() //Variable to store Philosopher objects
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        people.removeAll()  //clear the array
        philosopherObjects.removeAll()  //clear the array
        favoriteView.reloadData() //reload the table view
        //Create a search request for core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else{return}
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try manageContext.fetch(fetchRequest)
            self.tableView.reloadData()
            
        } catch let error as NSError{
            print("COULD NOT FETCH. \(error), \(error.description)")
            
        }
    }
    //Return number of sections in table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //Return number of elements in table view based off the number of elements in the core data array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    //Populate the table view with elements from the core data array and match those elements with those of the Philosophers plist
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! FavoritesTableViewCell
        let aPerson = people[indexPath.row]
        
        if(((aPerson.value(forKeyPath: "firstName") as? String)!) == ((aPerson.value(forKeyPath: "lastName") as? String)!)){
            cell.cellLabel.text = ((aPerson.value(forKeyPath: "firstName") as? String)!)
        }
        else{
            cell.cellLabel.text = ((aPerson.value(forKeyPath: "firstName") as? String)!) + " " + ((aPerson.value(forKeyPath: "lastName") as? String)!)
        }
        let path = Bundle.main.path(forResource: "Philosophers", ofType: "plist")!
        
        let philopherArray:NSArray = NSArray(contentsOfFile: path)!
        
        for item in philopherArray{
            let dictionary: [String:Any] = (item as? Dictionary)!
            if (((aPerson.value(forKeyPath: "firstName") as? String)!) == ((aPerson.value(forKeyPath: "lastName") as? String)!)){
                if ((dictionary["firstName"] as! String) == ((aPerson.value(forKeyPath: "firstName") as? String)!)){
                    let firstName = dictionary["firstName"]
                    let lastName = dictionary["lastName"]
                    let cellImage = dictionary["cellImage"]
                    
                    philosopherObjects.append(Philosophers(firstName: firstName as! String, lastName: lastName as! String, cellImage: cellImage as! String))
                    displayImage(imageURL: URL(string: dictionary["cellImage"] as! String)!, cell: cell)
                }
            }
            else if ((dictionary["firstName"] as! String) == (aPerson.value(forKeyPath: "firstName") as? String)! && (dictionary["lastName"] as! String) == (aPerson.value(forKeyPath: "lastName") as? String)! && (dictionary["birthDate"] as! String) == (aPerson.value(forKeyPath: "birthDate") as? String)!){
                let firstName = dictionary["firstName"]
                let lastName = dictionary["lastName"]
                let cellImage = dictionary["cellImage"]
                
                philosopherObjects.append(Philosophers(firstName: firstName as! String, lastName: lastName as! String, cellImage: cellImage as! String))
                displayImage(imageURL: URL(string: dictionary["cellImage"] as! String)!, cell: cell)
            }
        }
        return cell
    }
    
    //Instantiates a URL session to display an image from the given URL on the given cell
    func displayImage(imageURL: URL, cell: FavoritesTableViewCell){
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


    // MARK: - Navigation

    //Segue to the PhilosophersViewController by passing the first and last name for verification
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SHOWFAVORITE"){
            let destVC = segue.destination as! PhilosophersViewController
            if let indexPath = self.tableView.indexPathForSelectedRow{
                destVC.firstName = philosopherObjects[indexPath.row].firstName
                destVC.lastName = philosopherObjects[indexPath.row].lastName
            }
        }
    }
 

}


