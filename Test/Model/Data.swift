//
//  Data.swift
//  Test
//
//  Created by MacBookPro on 10/9/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
   @objc dynamic var cityName: String = ""
   //let cityArray = List<WeatherDataModel>()
    var weatherData = LinkingObjects(fromType: WeatherDataModel.self, property: "cities")
    
    
   
}
