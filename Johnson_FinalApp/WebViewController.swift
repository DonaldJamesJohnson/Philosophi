//
//  WebViewController.swift
//  Johnson_FinalApp
//
//  Copyright © 2019 DJ. All rights reserved.
//
//  Author: Donald Johnson
//  Purpose: Implement the web view

import UIKit
import WebKit

class WebViewController: UIViewController {
    //Link the web view component
    @IBOutlet weak var webView: WKWebView!
    //Segue input variable
    var www: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set URL
        let myURL = URL(string: www)
        //Create URL Request
        let urlRequest = URLRequest(url: myURL!)
        //Load URL Request
        webView.load(urlRequest)
    }
}
