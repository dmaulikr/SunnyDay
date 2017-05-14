//
//  ViewController.swift
//  Sunnyday
//
//  Created by Parth on 4/18/17.
//  Copyright © 2017 Bhoiwala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentForecast: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestURL: NSURL = NSURL(string: "https://api.apixu.com/v1/current.json?key=19838de8a1734bf187f232639171305&q=Philadelphia")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest){
            (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if(statusCode == 200){
                print("Data received")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    print(json as Any)
                    let current = json?["current"]
                    let location = json?["location"]
                   
                }catch {
                    print("Error with Json: \(error)")
                }
            }
            
        }
        task.resume()

    }
}

