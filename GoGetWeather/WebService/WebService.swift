//
//  WebService.swift
//  GoGetWeather
//
//  Created by Akond Asif Ur Rahman on 1/11/19.
//  Copyright © 2019 Akond Asif Ur Rahman. All rights reserved.
//

import UIKit

class WebService: NSObject {
    typealias tuple = (RootWeatherModel,[WeatherModel])
    
    func loadSources(completion :@escaping (tuple) -> ()) {
        let request = URLRequest(url:NSURL.init(string: "https://api.darksky.net/forecast/d5b68f05aca3b7fa8cde5b2d473ed986/33.8650,151.2094")! as URL)
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                let sourceDictionary = json as! NSDictionary
                let  rootWeatherModel = RootWeatherModel.init(dictionary: sourceDictionary)
                let dictionary = sourceDictionary["daily"] as! NSDictionary
                let dictionaries = dictionary["data"] as! [NSDictionary]
                let sources = dictionaries.compactMap(WeatherModel.init)
                let weatherTuple = (rootWeatherModel,sources)

                DispatchQueue.main.async {
                    completion(weatherTuple as! WebService.tuple)
                }
            }
            
            }.resume()
        
    }

}
