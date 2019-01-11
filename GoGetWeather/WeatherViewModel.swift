//
//  WeatherViewModel.swift
//  GoGetWeather
//
//  Created by Akond Asif Ur Rahman on 1/11/19.
//  Copyright © 2019 Akond Asif Ur Rahman. All rights reserved.
//

import UIKit

class WeatherViewModel: NSObject {
    var date :Date
    var summary :String
    var icon :String
    var temperatureHigh :Double
    var temperatureLow :Double

    init(weather :WeatherModel) {

        self.date = weather.date
        self.summary = weather.summary
        self.icon = weather.icon.prefix(1).uppercased() + weather.icon.lowercased().dropFirst()
        self.temperatureHigh = weather.temperatureHigh ?? 0.0
        self.temperatureLow = weather.temperatureLow ?? 0.0
        
        super.init()
    }
    

}
