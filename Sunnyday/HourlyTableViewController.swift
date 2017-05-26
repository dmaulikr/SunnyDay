//
//  HourlyTableViewController.swift
//  Sunnyday
//
//  Created by Parth on 5/25/17.
//  Copyright © 2017 Bhoiwala. All rights reserved.
//

import UIKit

class HourlyTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var hourlyForecast = NSArray()
    let forecastUrl:String = "https://api.apixu.com/v1/forecast.json?key=e763d5cf81a040e89b925722171605&q=Philadelphia"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHourlyWeather()
    }
    
    func getHourlyWeather(){
        let vc = ViewController()
        let weatherJson = vc.getWeatherJson(urlType: forecastUrl)
        if let forecastDict = weatherJson["forecast"] as? NSDictionary{
            if let forecastDay = forecastDict["forecastday"] as? NSArray{
                let fDay = forecastDay[0] as? NSDictionary
                if let hour = fDay?["hour"] as? NSArray{
                    print("hourly received")
                    print(hour)
                    hourlyForecast = hour
                }
            }
            
        }
        
        
    }

    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return hourlyForecast.count //thorwing error iin here
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HourlyTableViewCell
        cell.HourlyIcon.image = #imageLiteral(resourceName: "001lighticons-8").withRenderingMode(.alwaysTemplate)
        let hour = hourlyForecast[indexPath.row] as? NSDictionary
        let hourCondition = hour?["condition"] as! NSDictionary
        cell.HourlyCondition.text = (hourCondition["text"] as! NSString) as String
        let temp = hour?["temp_f"] as? NSNumber
        cell.HourlyTemp.text = String(describing: temp)
        return cell
    }



}
