//
//  Branches.swift
//  Johnson_FinalApp
//
//  Copyright © 2019 DJ. All rights reserved.
//
//  Author: Donald Johnson
//  Purpose: Create Branches class

import Foundation

class Branches: NSObject {
    var branch: String!
    var label: String!
    var information: String!
    var wiki: String!
    var sep: String!
    
    init(branch: String, label: String, information: String, wiki: String, sep: String){
        self.branch = branch
        self.label = label
        self.information = information
        self.wiki = wiki
        self.sep = sep
    }
}
