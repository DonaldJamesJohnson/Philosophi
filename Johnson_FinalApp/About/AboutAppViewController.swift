//
//  AboutAppViewController.swift
//
//  Copyright © 2019 NIU. All rights reserved.
//
// Author: Donald Johnson
// Purpose: To assign text to textView on the About App View.

import UIKit

class AboutAppViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    /*
     After this app finishes launching,
     this function assigns text to
     the AboutAppViewController.
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "About App"
        textView.text = "This is my final iOS application in CSCI 521 (iOS Mobile Device Programming) at NIU. The purpose of this application is to provide an index of philosophers and philosophical positions. The target audience for this application is anyone who is interested in philosophy. That includes those who know nothing about philosophy, but are interested in certain philosophical questions, as well as those who are studying philosophy or who may teach philosophy and would like to have access to an index of philosophers. The 'Branches' view allows the user to select from one of the five main areas of philosophical inquiry. The user is also able to search for a particular philosopher using the search bar, which takes them to a filtered collection view. When a branch is selected, the user is presented with information about that branch (with links to the SEP and Wiki pages), as well as a collection view of philosophers of that branch. If they would like to select a philosopher from that view, they will be presented with that philosopher's information view. The 'List' view displays the entire list of philosophers featured on this application, which may be sorted alphabetically or chronologically. The user may select a philosopher, which will take them to that philosopher's information view. The user is also able to search for a particular philosopher using the search bar, which filters the collection view. The 'map' view displays the origins of all the philosophers featured on this application. The annotation pins may be selected and will take the user to the philosopher's information view. The user is also able to search for a particular philosopher using the search bar, which will filter the map view. The 'Favorites' view displays a table of all favorited philosophers. The user may select a philosopher, which will take them to that philosopher's information view. The user is also capable of searching for a particular philosopher using the search bar which takes them to a filtered collection view. Finally, the philosopher information view presents the user with the following information: first and last name (if applicable), birth and death date, origin, major works (if applicable), a link to their SEP page (if applicable) and their Wiki page, their favorited status, and a text view containing a short description.\n\nDate: April 30, 2019\nVersion 1.0"
    }
}
