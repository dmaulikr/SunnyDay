//
//  HourlyTableViewController.swift
//  Sunnyday
//
//  Created by Parth on 5/25/17.
//  Copyright © 2017 Bhoiwala. All rights reserved.
//

import UIKit
import Foundation

class HourlyTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var hourlyForecast = NSArray()
//    let forecastUrl:String = "https://api.apixu.com/v1/forecast.json?key=e763d5cf81a040e89b925722171605&q=Seattle"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHourlyWeather()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHourlyWeather()
        
    }

    
    func fetchCache() -> NSDictionary {
        if let weather: NSDictionary = UserDefaults.standard.object(forKey: "weather_data") as! NSDictionary? {
            print("data cached back")
            print(weather)
            return weather
        }
        return [:]
    }
    
    func getHourlyWeather(){
        //let vc = ViewController()
        //let weatherJson = vc.getWeatherJson(urlType: forecastUrl)
        let forecast = fetchCache()
        print(forecast)
        if let forecast = fetchCache()["forecast"] as? NSDictionary {
            if let forecastDay = forecast["forecastday"] as? NSArray{
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
        return hourlyForecast.count 
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HourlyTableViewCell
        let hour = hourlyForecast[indexPath.row] as? NSDictionary
        let hourCondition = hour?["condition"] as! NSDictionary
        let temp = Int(truncating: (hour?["temp_f"] as? NSNumber)!)
        let time = (hour?["time"] as! NSString).components(separatedBy: " ")[1]
        let cond = (hourCondition["text"] as! NSString) as String
        cell.HourlyCondition.text = cond
        cell.HourlyTemp.text = String(describing: temp)
        cell.HourlyTime.text = getTimeInAmPmFormat(fullTime: time)
        cell.HourlyIcon.image = setIconForCondition(condition: cond).withRenderingMode(.alwaysTemplate)
        cell.layer.backgroundColor = UIColor(white: 1, alpha: 0.05).cgColor // cell transparency
        cell.layer.borderWidth = 3
        cell.layer.borderColor = setBackgroundColor().cgColor  // BACKGROUND
        tableView.backgroundColor = setBackgroundColor() // BACKGROUND
        DispatchQueue.main.async {
            tableView.reloadData()
        }
        return cell
    }

    public func setBackgroundColor() -> UIColor{
        //return UIColor(red:0.00, green:0.80, blue:0.80, alpha:1.0)
        //return UIColor(red:1.00, green:0.40, blue:0.40, alpha:1.0)
        return UIColor(red:0.17, green:0.26, blue:0.31, alpha:1.0)
    }
    
    
    public func getTimeInAmPmFormat(fullTime: String) -> String{
        let time = fullTime.components(separatedBy: ":")[0]
        let intTime = Int(time)
        if intTime! < 12{
            return time.replacingOccurrences(of: "0", with: "") + "AM"
        }else{
            if intTime != 12{
                return String(intTime! - 12) + "PM"
            }
            return time + "PM"
        }
    }

    
    func setIconForCondition(condition:String)-> UIImage{
        if (condition.lowercased().range(of: "partly") != nil){
            return #imageLiteral(resourceName: "icon-partly_cloudy")
        }else if (condition.lowercased().range(of: "sunny") != nil){
            return #imageLiteral(resourceName: "icon-sunny")
        }else if (condition.lowercased().range(of: "clear") != nil){
            return #imageLiteral(resourceName: "icon-clear_night")
        }else if (condition.lowercased().range(of: "cloudy") != nil) || (condition.lowercased().range(of: "overcast") != nil){
            return #imageLiteral(resourceName: "icon-cloudy")
        }else{
            return #imageLiteral(resourceName: "icon-rainy")
        }
    }
    
}
