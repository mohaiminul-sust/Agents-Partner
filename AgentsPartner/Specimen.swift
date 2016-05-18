//
//  Specimen.swift
//  Agents Partner
//
//  Created by Mohaiminul Islam on 5/18/16.
//  Copyright © 2016 infancyit. All rights reserved.
//

import Foundation
import RealmSwift

class Specimen: Object {
    dynamic var name = ""
    dynamic var desc = ""
    dynamic var lat = 0.0
    dynamic var lon = 0.0
    dynamic var created = NSDate()
    
    // MARK: relations
    dynamic var category: Category!
}

