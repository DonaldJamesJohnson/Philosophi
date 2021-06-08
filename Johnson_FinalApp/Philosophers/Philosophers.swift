//
//  Philosophers.swift
//  Johnson_FinalApp
//
//  Copyright © 2019 DJ. All rights reserved.
//
//  Author: Donald Johnson
//  Purpose: Create the Philosophers class

import Foundation

class Philosophers: NSObject{
    
    var firstName: String!
    var lastName: String!
    var birthDate: String!
    var deathDate: String!
    var information: String!
    var origin: String!
    var branches: [Bool]!
    var works: String!
    var wiki: String!
    var sep: String!
    var cellImage: String!
    var mainImage: String!
    
    init(firstName: String, lastName: String, birthDate: String, deathDate: String, information: String, works: String, origin: String, wiki: String, sep: String, mainImage: String){
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.deathDate = deathDate
        self.information = information
        self.origin = origin
        self.works = works
        self.wiki = wiki
        self.sep = sep
        self.mainImage = mainImage
    }
    
    init(firstName: String, lastName: String, cellImage: String){
        self.firstName = firstName
        self.lastName = lastName
        self.cellImage = cellImage
    }
    
    init(origin: String, firstName: String, lastName: String, cellImage: String!){
        self.origin = origin
        self.firstName = firstName
        self.lastName = lastName
        self.cellImage = cellImage
    }
    
    init(firstName: String, lastName: String, birthDate: String, deathDate: String, cellImage: String){
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.deathDate = deathDate
        self.cellImage = cellImage
    }
}
