//
//  RootWeatherViewModel.swift
//  GoGetWeather
//
//  Created by Akond Asif Ur Rahman on 1/11/19.
//  Copyright © 2019 Akond Asif Ur Rahman. All rights reserved.
//

import UIKit

class RootWeatherViewModel: NSObject {
    var currentWeather:CurrentWeatherModel?
    var timezone : String?
    init(rootWeather :RootWeatherModel) {
        self.timezone = rootWeather.timezone
        self.currentWeather = rootWeather.currentWeather
    }

}
