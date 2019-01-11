//
//  RootWeatherModel.swift
//  GoGetWeather
//
//  Created by Akond Asif Ur Rahman on 1/11/19.
//  Copyright © 2019 Akond Asif Ur Rahman. All rights reserved.
//

import UIKit

class RootWeatherModel: NSObject {
    var currentWeather:CurrentWeatherModel?
    var timezone : String?
    
    init?(dictionary : NSDictionary) {
        self.timezone = dictionary["timezone"] as? String
        self.currentWeather = CurrentWeatherModel.init(dictionary: (dictionary["currently"] as? NSDictionary)!)
        //        self.apparentTemperatureHigh = apparentTemperatureHigh
        
    }

}
