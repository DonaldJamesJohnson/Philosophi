//
//  FavoriteViewController.swift
//  Johnson_FinalApp
//
//  Created by DJ on 4/22/19.
//  Copyright © 2019 DJ. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "PhilosophersViewController") as! PhilosophersViewController
        
        /*
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
 */
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
