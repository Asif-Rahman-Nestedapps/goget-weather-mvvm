//
//  WeatherListViewModel.swift
//  GoGetWeather
//
//  Created by Akond Asif Ur Rahman on 1/11/19.
//  Copyright © 2019 Akond Asif Ur Rahman. All rights reserved.
//

import UIKit

class WeatherListViewModel: NSObject {
    private var token :NSKeyValueObservation?
    private var tokenRootWeather :NSKeyValueObservation?

    @objc dynamic private(set) var sourceViewModels :[WeatherViewModel] = [WeatherViewModel]()
    @objc dynamic private(set) var rootWeatherModel : RootWeatherModel  = RootWeatherModel.init(dictionary:        NSDictionary(objects: ["",NSDictionary(object: "", forKey: "temperature" as NSCopying)], forKeys: ["timezone" as NSCopying,"currently" as NSCopying])
)!

    private var webservice :WebService
    var bindToSourceViewModels :(() -> ()) = {  }

    init(webservice :WebService) {
        
        self.webservice = webservice
        super.init()
        token = self.observe(\.sourceViewModels) { _,_ in
            self.bindToSourceViewModels()
        }

        token = self.observe(\.rootWeatherModel) { _,_ in
            self.bindToSourceViewModels()
        }

        // call populate sources
        populateSources()
    }
    
    func populateSources() {
        
        self.webservice.loadSources { [unowned self] sources in
            self.sourceViewModels = sources.1.compactMap(WeatherViewModel.init)
            self.rootWeatherModel = sources.0
        }
    }

}
