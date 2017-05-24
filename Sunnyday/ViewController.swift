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

    let forecastUrl:String = "https://api.apixu.com/v1/forecast.json?key=e763d5cf81a040e89b925722171605&q=Philadelphia"
    
    var tempf = 00
    var humid = 00
    var windMph = 00
    var windDir = "ABC"
    var condition = "No Data"
    var location = "Null Island"
    var dayHigh = 00
    var dayLow = 00
    
    //@IBAction func rightSwiper(_ sender: Any) {
      //  print("Swiped")
    //}
    
    /*@IBAction func RightSwiper(_ sender: Any) {
    print("swiped right")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SecondViewController")
        self.present(controller, animated: true, completion: nil)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let forecastJson:NSDictionary = getWeatherJson(urlType: forecastUrl)
        print(forecastJson)
        parseWeatherInfo(weatherJson: forecastJson)
        refreshUI()
        putConditionIcon()
        // createGradientLayer()
        
      

    }
    
    func putConditionIcon(){
        imgView.image = #imageLiteral(resourceName: "001lighticons-8").withRenderingMode(.alwaysTemplate)
        imgView.tintColor = UIColor.white

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
        //var weatherJson = [String:AnyObject]()
        var weatherJson = NSDictionary()
        let task = session.dataTask(with: urlRequest as URLRequest){
            (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if(statusCode == 200){
                print("Data received")
                do{
                    //weatherJson = try JSONSerialization.jsonObject(with: data!) as! [String: AnyObject]
                    weatherJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    //print(json as Any)
                    //let current = json?["current"]
                    //let location = json?["location"]
                    
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
        gradientLayer.colors = [UIColor(red:0.00, green:0.47, blue:0.57, alpha:1.0).cgColor,
                                UIColor(red:0.47, green:1.00, blue:0.84, alpha:1.0).cgColor]
        self.view.layer.addSublayer(gradientLayer)
    
    }

}


extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


class SegueFromRight: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.curveEaseInOut,
                                   animations: {
                                    dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                                   completion: { finished in
                                    src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

