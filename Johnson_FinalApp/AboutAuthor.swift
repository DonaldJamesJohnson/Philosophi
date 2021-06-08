//
//  AboutAuthor.swift
//  Johnson_FinalApp
//
//  Copyright © 2019 NIU. All rights reserved.
//
// Author: Donald Johnson
// Purpose: Display a local web page (About Author) using the WebKit framework.

import UIKit
import WebKit

class AboutAuthor: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "About Author"
        
        let path = Bundle.main.path(forResource: "index", ofType: "html")

        let data: Data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        
        let html = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        webView.loadHTMLString(html! as String, baseURL: Bundle.main.bundleURL)
    }
}
