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
    private var isMorePressed :Bool!

    //MARK:- View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isMorePressed = false;
        weatherTableView.layer.shadowColor = UIColor.black.cgColor
        weatherTableView.layer.shadowOpacity = 0.5
        weatherTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        weatherTableView.layer.shadowRadius = 1
        weatherTableView.backgroundColor = UIColor.clear
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
    
    //MARK:- UI Update Methods
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
        case (String(weatherStatus.contains("fog") || weatherStatus == "fog")):
            headerLabel.textColor = UIColor.black
            return UIColor.init(red:220/255, green: 237/255, blue: 200/255, alpha: 1.0)

        default:
            return UIColor.init(red:155.0/255, green: 155/255, blue: 155/255, alpha: 1.0)
        }
    }

    //MARK:- UITableViewDataSource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return 3;
        }else{
            return self.weatherListViewModel.sourceViewModels.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath)
        guard let weatherCell = cell as? WeatherTableViewCell else {
            return cell
        }
        if indexPath.section == 1 {
            weatherCell.dateLabel.text  = Utility.stringFromDate(date: Calendar.current.date(byAdding: Calendar.Component.day, value: indexPath.row, to: Date())!
            )
        }else{
            let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to:Calendar.current.date(byAdding:Calendar.Component.day,value:indexPath.row, to: Date())!).day
            
            var dayString = "";
            switch diffInDays {
            case 1:
                dayString = "Tomorrow"
                break
            case 0:
            dayString = "Today"
            break
            case 2:
            dayString = "Day After Tomorrow"
            break
            default:
                break
            }
            weatherCell.dateLabel.text = dayString

        }
        let vm = self.weatherListViewModel.sourceViewModels[indexPath.row]
        weatherCell.summaryLabel.text = vm.icon
        weatherCell.temperatureLabel.text = NSString.init(format: "%.2f/%.2f °F",vm.temperatureLow,vm.temperatureHigh ) as String
        return weatherCell;
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return nil
        }else{
            let headerVIew = UIView.init(frame: CGRect(x:0,y:0,width:tableView.frame.size.width,height:40))
            headerVIew.backgroundColor = containerView.backgroundColor;
            let moreActionButton = UIButton.init(frame: CGRect(x:0,y:0,width:120,height:40))
            moreActionButton.addTarget(self, action: #selector(moreActionButtonPressed), for: .touchUpInside)
            moreActionButton.setTitleColor(headerLabel.textColor, for: .normal)
            if(!isMorePressed){
                moreActionButton.setTitle("Show more", for: .normal)
            }else{
                moreActionButton.setTitle("Show less", for: .normal)
            }
            headerVIew.addSubview(moreActionButton)
            return headerVIew
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil;
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40;
        }
        return 0.01;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isMorePressed {
            return 2;
        }else{
            return 1;
        }
    }
    //MARK:- ButtonAction
    
    @objc func moreActionButtonPressed(sender:UIButton)  {
        if !isMorePressed {
            isMorePressed = true
            self.weatherTableView.beginUpdates();
            self.weatherTableView.insertSections(NSIndexSet.init(index: 1) as IndexSet, with: .bottom)
            self.weatherTableView.endUpdates();
            sender.setTitle("Show less", for: .normal)
            
        }else{
            isMorePressed = false
            self.weatherTableView.beginUpdates();
            self.weatherTableView.deleteSections(NSIndexSet.init(index: 1) as IndexSet, with: .top)
            self.weatherTableView.endUpdates();
            sender.setTitle("Show more", for: .normal)
        }
    }



}

