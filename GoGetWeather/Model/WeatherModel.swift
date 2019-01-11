//
//  WeatherModel.swift
//  GoGetWeather
//
//  Created by Akond Asif Ur Rahman on 1/11/19.
//  Copyright © 2019 Akond Asif Ur Rahman. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
    var date :Date
    var summary :String
    var icon :String
    var temperatureHigh :Double?
    var temperatureLow :Double?

    init?(dictionary : NSDictionary) {
        self.date = Date()
        let summaryValue = dictionary["summary"] as? String
        let iconValue = dictionary["icon"] as? String
        let temperatureHighValue = dictionary["temperatureHigh"] as? Double
        let temperatureLowAValue = dictionary["temperatureLow"] as? Double
        self.summary = summaryValue ?? ""
        self.icon = iconValue ?? ""
        self.temperatureHigh = temperatureHighValue
        self.temperatureLow = temperatureLowAValue
//        self.apparentTemperatureHigh = apparentTemperatureHigh

    }
    
    init(viewModel :WeatherViewModel) {
        self.date = viewModel.date
        self.summary = viewModel.summary
        self.icon = viewModel.icon
        self.temperatureHigh = viewModel.temperatureHigh
        self.temperatureLow = viewModel.temperatureLow
    }

}
