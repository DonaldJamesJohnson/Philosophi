//
//  BranchesViewController.swift
//  Johnson_FinalApp
//
//  Copyright © 2019 DJ. All rights reserved.
//
//  Author: Donald Johnson
//  Purpose: Implement functionality of the Branches view controller

import UIKit

class BranchesViewController: UIViewController, UISearchBarDelegate {
    
    //Link search bar component
    @IBOutlet weak var searchBar: UISearchBar!
    var branchObjects = [Branches]() //Create array of Branch objects
    var searchResults = [Philosophers]() //Create array of Philosopher objects
    
    //Read the property list and store the data in branchObjects
    func readPropertyList(){
        
        let path = Bundle.main.path(forResource: "Branches", ofType: "plist")! //access property list
        
        let recipeArray:NSArray = NSArray(contentsOfFile: path)!
        
        //assign each variable of Recipes property list to variable of Recipes class
        for item in recipeArray{
            let dictionary: [String:Any] = (item as? Dictionary)!
            
            let branch = dictionary["Branch"]
            let label = dictionary["Label"]
            let information = dictionary["Information"]
            let wiki = dictionary["Wiki"]
            let sep = dictionary["SEP"]
            
            branchObjects.append(Branches(branch: branch! as! String, label: label! as! String, information: information! as! String, wiki: wiki! as! String, sep: sep! as! String))
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
    }
    //Segue to the appropriate view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "AESTHETICSSEGUE"){
            let destVC = segue.destination as! BranchesDetailViewController
            
            destVC.branch = branchObjects[0].branch
            destVC.information = branchObjects[0].information
            destVC.wiki = branchObjects[0].wiki
            destVC.sep = branchObjects[0].sep 
        }
        else if (segue.identifier == "EPISTEMOLOGYSEGUE"){
            let destVC = segue.destination as! BranchesDetailViewController
            
            destVC.branch = branchObjects[1].branch
            destVC.information = branchObjects[1].information
            destVC.wiki = branchObjects[1].wiki
            destVC.sep = branchObjects[1].sep
        }
        else if (segue.identifier == "ETHICSSEGUE"){
            let destVC = segue.destination as! BranchesDetailViewController
            
            destVC.branch = branchObjects[2].branch
            destVC.information = branchObjects[2].information
            destVC.wiki = branchObjects[2].wiki
            destVC.sep = branchObjects[2].sep
        }
        else if (segue.identifier == "METAPHYSICSSEGUE"){
            let destVC = segue.destination as! BranchesDetailViewController
            
            destVC.branch = branchObjects[3].branch
            destVC.information = branchObjects[3].information
            destVC.wiki = branchObjects[3].wiki
            destVC.sep = branchObjects[3].sep
        }
        else if (segue.identifier == "POLITICSSEGUE"){
            let destVC = segue.destination as! BranchesDetailViewController
            
            destVC.branch = branchObjects[4].branch
            destVC.information = branchObjects[4].information
            destVC.wiki = branchObjects[4].wiki
            destVC.sep = branchObjects[4].sep
        }
    }
}
