//
//  PersonInfo.swift
//  SMSpotlightSearchViewDemo
//
//  Created by Si Ma on 7/19/17.
//

import Foundation

enum Gender: Int {
    case Male
    case Female
    case Other
}

class PersonInfo {
    let name: String
    let surname: String
    let gender: Gender
    let region: String
    
    init(name: String, surname: String, gender: Gender, region: String) {
        self.name = name
        self.surname = surname
        self.gender = gender
        self.region = region
    }
}

extension PersonInfo: CustomStringConvertible {
    var description: String {
        return "\(self.name) \(self.surname), \(self.gender), is from \(self.region)"
    }
}
