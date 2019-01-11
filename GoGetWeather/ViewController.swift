//
//  ViewController.swift
//  GoGetWeather
//
//  Created by Akond Asif Ur Rahman on 1/11/19.
//  Copyright © 2019 Akond Asif Ur Rahman. All rights reserved.
//

import UIKit
import MBProgressHUD
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var weatherTableView: UITableView!
    private var webservice :WebService!
    private var weatherListViewModel :WeatherListViewModel!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.layer.shadowColor = UIColor.black.cgColor
        weatherTableView.layer.shadowOpacity = 0.5
        weatherTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        weatherTableView.layer.shadowRadius = 1
        
        weatherTableView.rowHeight = UITableView.automaticDimension;
        weatherTableView.estimatedRowHeight = 80.0
        weatherTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 1
        
        let cellNib = UINib.init(nibName: "WeatherTableViewCell", bundle: Bundle.main)
                weatherTableView.register(cellNib, forCellReuseIdentifier: "WeatherTableViewCell")
        updateUI()
    }
    private func updateUI() {
        
        DispatchQueue.main.async {
            Utility.showProgressView(view: self.view)
            self.containerView.isHidden  = true
        }
        self.webservice = WebService()
        self.weatherListViewModel = WeatherListViewModel(webservice: self.webservice)
        self.weatherListViewModel.bindToSourceViewModels = {
            self.updateDataSource()
        }
    }
    
    private func updateDataSource() {
        headerLabel.text = NSString.init(format: "%.2f °F %@ \n %@ ", (weatherListViewModel.rootWeatherModel.currentWeather?.temperature ?? ""),(weatherListViewModel.rootWeatherModel.currentWeather?.summary ?? ""),weatherListViewModel.rootWeatherModel.timezone ?? "") as String
        weatherTableView.dataSource = self;
        weatherTableView.delegate = self;
        self.weatherTableView.reloadData()
      containerView.backgroundColor =   setBgColorAccordingToWeather(weatherStatus: weatherListViewModel.sourceViewModels[0].icon);
        DispatchQueue.main.async {
            Utility.hideProgressView(view: self.view)
            self.containerView.isHidden  = false
        }
    }

    func setBgColorAccordingToWeather(weatherStatus:String) -> UIColor {
        let weatherStatus = weatherStatus.lowercased();
        
        switch "true" {
        case (String(weatherStatus.contains("cloud") || weatherStatus == "cloud")):
            return UIColor.init(red:126/255 , green: 135/255, blue: 150/255, alpha: 1.0)
        case (String(weatherStatus.contains("rain") || weatherStatus == "rain")):
            return UIColor.init(red:144/255 , green: 202/255, blue: 249/255, alpha: 1.0)

        case (String(weatherStatus.contains("snow") || weatherStatus == "snow")):
            headerLabel.textColor = UIColor.black
            return UIColor.init(red:238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
        case (String(weatherStatus.contains("wind") || weatherStatus == "wind")):
            headerLabel.textColor = UIColor.black
            return UIColor.init(red:155.0/255, green: 155/255, blue: 155/255, alpha: 1.0)

        default:
            return UIColor.init(red:155.0/255, green: 155/255, blue: 155/255, alpha: 1.0)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherListViewModel.sourceViewModels.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath)
        guard let weatherCell = cell as? WeatherTableViewCell else {
            return cell
        }
        weatherCell.dateLabel.text  = stringFromDate(date: Calendar.current.date(byAdding: Calendar.Component.day, value: indexPath.row, to: Date())!
        )
        let vm = self.weatherListViewModel.sourceViewModels[indexPath.row]
        weatherCell.summaryLabel.text = vm.icon
        weatherCell.temperatureLabel.text = NSString.init(format: "%.2f/%.2f °F",vm.temperatureLow,vm.temperatureHigh ) as String
        return weatherCell;
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    func stringFromDate(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = formatter.string(from: date)
        return myString
    }


}

