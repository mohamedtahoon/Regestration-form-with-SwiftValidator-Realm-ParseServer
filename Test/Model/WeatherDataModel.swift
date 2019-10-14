//
//  WeatherDataModel.swift
//  Test
//
//  Created by MacBookPro on 10/8/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherDataModel: Object{
    let cities = List<Data>()
    @objc dynamic var cityName : String = ""
   // @objc dynamic var id = 0
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
   // var cityy = LinkingObjects(fromType: Data.self, property: "cities")
}
