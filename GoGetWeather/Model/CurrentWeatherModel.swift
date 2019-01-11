//
//  CurrentWeatherModel.swift
//  GoGetWeather
//
//  Created by Akond Asif Ur Rahman on 1/11/19.
//  Copyright © 2019 Akond Asif Ur Rahman. All rights reserved.
//

import UIKit

class CurrentWeatherModel: NSObject {
    var temperature: Double?
    var summary: String?

    init?(dictionary : NSDictionary) {
        self.temperature = dictionary["temperature"] as? Double
        self.summary = dictionary["summary"] as? String

    }
}
