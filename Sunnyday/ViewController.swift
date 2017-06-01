//
//  ViewController.swift
//  Sunnyday
//
//  Created by Parth on 4/18/17.
//  Copyright © 2017 Bhoiwala. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDelegate {
    
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentForecast: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    let forecastUrl:String = "https://api.apixu.com/v1/forecast.json?key=e763d5cf81a040e89b925722171605&q=Seattle"
    
    var tempf = 00
    var humid = 00
    var windMph = 00
    var windDir = "ABC"
    var condition = "No Data"
    var location = "Null Island"
    var dayHigh = 00
    var dayLow = 00
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let forecastJson:NSDictionary = getWeatherJson(urlType: forecastUrl)
        print(forecastJson)
        parseWeatherInfo(weatherJson: forecastJson)
        refreshUI()
        createGradientLayer()
        
        
    }
    

    
    
    
    func parseWeatherInfo(weatherJson: NSDictionary){
        if let locationDict = weatherJson["location"] as? NSDictionary{
            location = locationDict["name"] as! String
        }
        if let currentDict = weatherJson["current"] as? NSDictionary{
            tempf = Int(currentDict["temp_f"] as! NSNumber)
            windMph = (Int(currentDict["wind_mph"] as! NSNumber))
            windDir = (currentDict["wind_dir"] as? String)!
            humid = (Int(currentDict["humidity"] as! NSNumber))
            if let cond = currentDict["condition"] as? NSDictionary{
                condition = cond["text"] as! String
            }
            imgView.image = setIconForCondition(condition: condition).withRenderingMode(.alwaysTemplate)
            imgView.tintColor = UIColor.white
        }
        if let forecastDict = weatherJson["forecast"] as? NSDictionary{
            if let forecastDay = forecastDict["forecastday"] as? NSArray{
                let fDay = forecastDay[0] as? NSDictionary
                if let day = fDay?["day"] as? NSDictionary{
                    dayHigh = Int(day["maxtemp_f"] as! NSNumber)
                    dayLow = Int(day["mintemp_f"] as! NSNumber)
                }
            }
        }
        
        
    }
    
    
    
    func refreshUI(){
        currentTemp.text = String(tempf)
        wind.text = String(windMph) + " " + windDir
        city.text = location
        currentForecast.text = condition
        humidity.text = String(humid) + "%"
        low.text = String(dayLow)
        high.text = String(dayHigh)
    }
    
    
    func getWeatherJson(urlType: String) -> NSDictionary{
        let semaphore = DispatchSemaphore(value: 0)
        let requestURL: NSURL = NSURL(string: urlType)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        var weatherJson = NSDictionary()
        let task = session.dataTask(with: urlRequest as URLRequest){
            (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if(statusCode == 200){
                print("Data received")
                do{
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
        var gradientLayer:CAGradientLayer!
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        //gradientLayer.colors = [UIColor(red:0.00, green:0.47, blue:0.57, alpha:1.0).cgColor,
        //                        UIColor(red:0.47, green:1.00, blue:0.84, alpha:1.0).cgColor]
        gradientLayer.colors = [UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0).cgColor,
                                UIColor(red:0.30, green:0.63, blue:0.69, alpha:1.0).cgColor]
        
        self.view.layer.addSublayer(gradientLayer)
        
    }
    
    func setIconForCondition(condition:String)-> UIImage{
        if (condition.lowercased().range(of: "partly") != nil){
            return #imageLiteral(resourceName: "icon-partly_cloudy")
        }else if (condition.lowercased().range(of: "sunny") != nil){
            return #imageLiteral(resourceName: "icon-sunny")
        }else if (condition.lowercased().range(of: "clear") != nil){
            return #imageLiteral(resourceName: "icon-clear_night")
        }else if (condition.lowercased().range(of: "cloudy") != nil){
            return #imageLiteral(resourceName: "icon-cloudy")
        }else{
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


