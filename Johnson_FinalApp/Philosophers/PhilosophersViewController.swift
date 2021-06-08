//
//  PhilosophersViewController.swift
//  Johnson_FinalApp
//
//  Copyright © 2019 DJ. All rights reserved.
//
//  Author: Donald Johnson
//  Purpose: Implement the functionality of the philosopher view controller

import UIKit
import CoreData

class PhilosophersViewController: UIViewController {
    //Segue input variables
    var firstName: String!
    var lastName: String!
    var philosopherObjects = [Philosophers]()
    var people: [NSManagedObject] = []
    var saved: Bool = false
    //Link the view components
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var worksLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var sepButton: UIButton!
    @IBOutlet weak var originLabel: UILabel!
    @IBAction func originButton(_ sender: Any) {
        
    }
    //Action for favorite button
    @IBAction func favButton(_ sender: Any) {
        let title = NSLocalizedString("Add to Favorites", comment: "")
        let message = NSLocalizedString("Would you like to add this philosopher to your favorites?", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let okButtonTitle = NSLocalizedString("Add", comment: "")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in  }
        let okAction = UIAlertAction(title: okButtonTitle, style: .default) { _ in
            self.save()
        }
        alertController.addAction(cancelAction)
        alertController.addAction((okAction))
        present(alertController, animated: true, completion: nil)
    }
    //Action for remove button
    @IBAction func removeButton(_ sender: Any) {
        let title = NSLocalizedString("Remove from Favorites", comment: "")
        let message = NSLocalizedString("Would you like to remove this philosopher from your favorites?", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let okButtonTitle = NSLocalizedString("Remove", comment: "")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in }
        let okAction = UIAlertAction(title: okButtonTitle, style: .default) { _ in
            self.remove()
        }
        alertController.addAction(cancelAction)
        alertController.addAction((okAction))
        present(alertController, animated: true, completion: nil)
    }
    @IBOutlet weak var favButtonOut: UIButton!
    @IBOutlet weak var removeButtonOut: UIButton!
    
    //Read the Philosophers plist and store the data in philosopherObjects
    func readPropertyList(){
        let path = Bundle.main.path(forResource: "Philosophers", ofType: "plist")!
        
        let philopherArray:NSArray = NSArray(contentsOfFile: path)!
        
        for item in philopherArray{
            let dictionary: [String:Any] = (item as? Dictionary)!
            
            if ((dictionary["firstName"] as! String) == firstName && lastName == firstName){
                let image = dictionary["mainImage"]
                let first = dictionary["firstName"]
                let last = dictionary["lastName"]
                let birth = dictionary["birthDate"]
                let death = dictionary["deathDate"]
                let information = dictionary["information"]
                let works = dictionary["works"]
                let origin = dictionary["origin"]
                let wiki = dictionary["wiki"]
                let sep = dictionary["sep"]
                
                philosopherObjects.append(Philosophers(firstName: first as! String, lastName: last as! String, birthDate: birth as! String, deathDate: death as! String, information: information as! String, works: works as! String, origin: origin as! String, wiki: wiki as! String, sep: sep as! String, mainImage: image as! String))
                displayImage(imageURL: URL(string: philosopherObjects[0].mainImage)!, image: imageView)
            }
            else if ((dictionary["firstName"] as! String) == firstName && (dictionary["lastName"] as! String) == lastName){
                let image = dictionary["mainImage"]
                let first = dictionary["firstName"]
                let last = dictionary["lastName"]
                let birth = dictionary["birthDate"]
                let death = dictionary["deathDate"]
                let information = dictionary["information"]
                let works = dictionary["works"]
                let origin = dictionary["origin"]
                let wiki = dictionary["wiki"]
                let sep = dictionary["sep"]
            
                philosopherObjects.append(Philosophers(firstName: first as! String, lastName: last as! String, birthDate: birth as! String, deathDate: death as! String, information: information as! String, works: works as! String, origin: origin as! String, wiki: wiki as! String, sep: sep as! String, mainImage: image as! String))
                displayImage(imageURL: URL(string: philosopherObjects[0].mainImage)!, image: imageView)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readPropertyList()
        //Check to see if their first name == their last name (in cases where there is only one name, e.g 'Aristotle')
        if (philosopherObjects[0].firstName == philosopherObjects[0].lastName){
            nameLabel.text = philosopherObjects[0].firstName
        }
        else{
            nameLabel.text = philosopherObjects[0].firstName + " " + philosopherObjects[0].lastName
        }
        //Check to see if they were born before year 0
        if (philosopherObjects[0].birthDate.first == "-"){
           philosopherObjects[0].birthDate.remove(at: philosopherObjects[0].birthDate.startIndex)
            if(philosopherObjects[0].deathDate.first == "-"){
                philosopherObjects[0].deathDate.remove(at: philosopherObjects[0].deathDate.startIndex)
                dateLabel.text = philosopherObjects[0].birthDate + "-" + philosopherObjects[0].deathDate
            }
            else{
                dateLabel.text = philosopherObjects[0].birthDate + "-" + philosopherObjects[0].deathDate
            }
        }
        else{
            dateLabel.text = philosopherObjects[0].birthDate + "-" + philosopherObjects[0].deathDate
        }
        //Populate the form components with data
        worksLabel.text = "Major Works: " + philosopherObjects[0].works
        infoTextView.text = philosopherObjects[0].information
        originLabel.text = philosopherObjects[0].origin
        if (philosopherObjects[0].sep == "none"){
            sepButton.isHidden = true
        }
        favButtonOut.isHidden = false
        favButtonOut.isEnabled = true
        removeButtonOut.isHidden = true
        removeButtonOut.isEnabled = false
        //Create a fetch request for core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else{return}
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people.removeAll()
            people = try manageContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("COULD NOT FETCH. \(error), \(error.description)")
            
        }
        //If the current philosopher is favorited, then the favorite button is visible and enabled, else the remove button is.
        for p in people{
            if (p.value(forKey: "firstName") != nil && p.value(forKey: "lastName") != nil){
                if ((p.value(forKey: "firstName") as! String) == philosopherObjects[0].firstName && (p.value(forKey: "lastName") as! String) == philosopherObjects[0].lastName){
                    
                    favButtonOut.isHidden = true
                    favButtonOut.isEnabled = false
                    removeButtonOut.isHidden = false
                    removeButtonOut.isEnabled = true
                    break
                }
                else {
                    favButtonOut.isHidden = false
                    favButtonOut.isEnabled = true
                    removeButtonOut.isHidden = true
                    removeButtonOut.isEnabled = false
                }
            }
            else {
            }
        }
    }
    //Instantiates a URL session to display an image from the given URL in the given image view
    func displayImage(imageURL: URL, image: UIImageView){
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: imageURL, completionHandler: {
            (imageData, response, error) in
            if let downloadImage = imageData {
                if let dImage = UIImage(data: downloadImage)
                {
                    DispatchQueue.main.async {
                        image.image = dImage
                    }
                }
            }
        }).resume()
    }
    //Saves a philosopher to core data and updates status of the favorite and remove buttons
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let personEntity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: personEntity, insertInto: managedContext)
        
        
        person.setValue(philosopherObjects[0].firstName, forKey: "firstName")
        person.setValue(philosopherObjects[0].lastName, forKey: "lastName")
        person.setValue(philosopherObjects[0].birthDate, forKey: "birthDate")
        person.setValue(philosopherObjects[0].cellImage, forKey: "cellImage")
        do{
            try managedContext.save()
            people.append(person)
            favButtonOut.isHidden = true
            favButtonOut.isEnabled = false
            removeButtonOut.isHidden = false
            removeButtonOut.isEnabled = true
        }
        catch let error as NSError{
            print("COULD NOT SAVE. \(error), \(error.description)")
        }
    }
    //Removes a philosopher from core data and updates the status of the favorite and remove buttons
    func remove(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else{return}
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try manageContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("COULD NOT FETCH. \(error), \(error.description)")
            
        }
        for p in people{
            if (p.value(forKey: "firstName") != nil && p.value(forKey: "lastName") != nil){
                if ((p.value(forKey: "firstName") as! String) == philosopherObjects[0].firstName && (p.value(forKey: "lastName") as! String) == philosopherObjects[0].lastName){
                    manageContext.delete(p)
                    favButtonOut.isHidden = false
                    favButtonOut.isEnabled = true
                    removeButtonOut.isHidden = true
                    removeButtonOut.isEnabled = false
                    do {
                        try manageContext.save()
                    }
                    catch let error as NSError{
                        print("COULD NOT SAVE. \(error), \(error.description)")
                        
                    }
                }
            }
        }
    }

    // MARK: - Navigation

    //Segue to the appropriate view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PHILOWIKISHOW"){
            let destVC = segue.destination as! WebViewController
            destVC.navigationItem.backBarButtonItem?.title = lastName
            destVC.www = philosopherObjects[0].wiki
        }
        else if (segue.identifier == "PHILOSEPSHOW"){
            let destVC = segue.destination as! WebViewController
            navigationItem.backBarButtonItem?.title = lastName
            destVC.www = philosopherObjects[0].sep
        }
        else if (segue.identifier == "SHOWORIGIN"){
            let destVC = segue.destination as! MapViewController
            destVC.origin = philosopherObjects[0].origin
            destVC.fName = philosopherObjects[0].firstName
            destVC.lName = philosopherObjects[0].lastName
        }
    }

}
