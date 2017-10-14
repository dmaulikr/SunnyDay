//
//  ViewController.swift
//  Sunnyday
//
//  Created by Parth on 4/18/17.
//  Copyright © 2017 Bhoiwala. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    
    
    let forecastUrl:String = "https://api.apixu.com/v1/forecast.json?key=e763d5cf81a040e89b925722171605&q="
    let defaultLocation = "Seattle"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
        updateWeather(city: defaultLocation)
        locationTextField.addTarget(self, action: #selector(updateLocation(textField:)), for: .primaryActionTriggered)
        
    }
    
    func updateWeather(city: String) {
        let url: String = forecastUrl + city
        let forecastJson:NSDictionary = getWeatherJson(urlType: url)
        cacheData(forecastJson: forecastJson)
        //print(forecastJson)
        let currentWeather = parseWeatherInfo(weatherJson: forecastJson)
        refreshUI(weather: currentWeather)
        
    }
    
    @objc func updateLocation(textField: UITextField) {
        textField.resignFirstResponder()
        print(textField.text!)
        updateWeather(city: textField.text!)
    }
    
    // Hide
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print(textField.text!)
        return true
    }
    
    func parseWeatherInfo(weatherJson: NSDictionary) -> CurrentWeather {
        let currentWeather = CurrentWeather()
        if let locationDict = weatherJson["location"] as? NSDictionary {
            currentWeather.location = locationDict["name"] as! String
        }
        
        if let currentDict = weatherJson["current"] as? NSDictionary {
            currentWeather.temperature = Int(truncating: currentDict["temp_f"] as! NSNumber)
            currentWeather.humidity = (Int(truncating: currentDict["humidity"] as! NSNumber))
            currentWeather.wind_mph = (Int(truncating: currentDict["wind_mph"] as! NSNumber))
            currentWeather.wind_dir = (currentDict["wind_dir"] as? String)!
            if let cond = currentDict["condition"] as? NSDictionary {
                currentWeather.condition = cond["text"] as! String
            }
        }
        
        if let forecastDict = weatherJson["forecast"] as? NSDictionary {
            if let forecastDay = forecastDict["forecastday"] as? NSArray {
                let fDay = forecastDay[0] as? NSDictionary
                if let day = fDay?["day"] as? NSDictionary{
                    currentWeather.low_temp = Int(truncating: day["mintemp_f"] as! NSNumber)
                    currentWeather.high_temp = Int(truncating: day["maxtemp_f"] as! NSNumber)
                }
            }
        }
        
      return currentWeather
    }

    
    func cacheData(forecastJson: NSDictionary) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(forecastJson, forKey: "weather_data")
        userDefaults.synchronize()
    }
    
    func refreshUI(weather: CurrentWeather ) {
        currentTempLabel.text = String(weather.temperature)
        windLabel.text = String(weather.wind_mph) + " " + weather.wind_dir
        locationLabel.text = weather.location
        conditionLabel.text = weather.condition
        humidityLabel.text = String(weather.humidity) + "%"
        lowTempLabel.text = String(weather.low_temp)
        highTempLabel.text = String(weather.high_temp)
        imgView.image = setIconForCondition(condition: weather.condition).withRenderingMode(.alwaysTemplate)
        imgView.tintColor = UIColor.white
    }
    
    func getWeatherJson(urlType: String) -> NSDictionary {
        let semaphore = DispatchSemaphore(value: 0)
        let requestURL: NSURL = NSURL(string: urlType)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        var weatherJson = NSDictionary()
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Data received")
                do {
                    weatherJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                }catch {
                    print("Error with Json: \(error)")
                }
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return weatherJson
    }
    
    func createGradientLayer() {
//        var gradientLayer:CAGradientLayer!
//        gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.view.bounds
//        gradientLayer.colors = [UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0).cgColor,
//                                UIColor(red:0.30, green:0.63, blue:0.69, alpha:1.0).cgColor]
//        self.view.layer.addSublayer(gradientLayer)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "forest.png")!)
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view.addSubview(blurEffectView)
        
    }
    
    func setIconForCondition(condition: String)-> UIImage {
        if (condition.lowercased().range(of: "partly") != nil) {
            return #imageLiteral(resourceName: "icon-partly_cloudy")
        } else if (condition.lowercased().range(of: "sunny") != nil) {
            return #imageLiteral(resourceName: "icon-sunny")
        } else if (condition.lowercased().range(of: "clear") != nil) {
            return #imageLiteral(resourceName: "icon-clear_night")
        } else if (condition.lowercased().range(of: "cloudy") != nil) {
            return #imageLiteral(resourceName: "icon-cloudy")
        } else {
            return #imageLiteral(resourceName: "icon-rainy")
        }
    }
    
    
    
    
} // end of class


/*extension UIImage {
 func resizeImage(newWidth: CGFloat) -> UIImage {
 
 let scale = newWidth / self.size.width
 let newHeight = self.size.height * scale
 UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
 self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
 let newImage = UIGraphicsGetImageFromCurrentImageContext()
 UIGraphicsEndImageContext()
 
 return newImage!
 }
 }*/


