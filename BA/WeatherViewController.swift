//
//  WeatherViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 17.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet var weatherView: WeatherView?
    
    var contextHandler: ContextHandler?
    
    var accessory : IAccessory? {
        didSet {
            if accessory?.characteristics != nil {
                characteristics = accessory!.characteristics
            }
        }
    }
    
    var characteristics : [CharacteristicKey:AnyObject]? {
        didSet {
            if let chars = characteristics {
                if !chars.isEmpty {
                    print("set Characteristics in VC: \((accessory?.name)!)")
                    serviceName = chars.filter{ $0.0 == CharacteristicKey.serviceName }.first.map{ $0.1 as! String }
                    pressure = chars.filter{ $0.0 == CharacteristicKey.pressure }.first.map{ $0.1 as! Float }
                    humidity = chars.filter{ $0.0 == CharacteristicKey.humidity }.first.map{ $0.1 as! Float }
                    temp = chars.filter{ $0.0 == CharacteristicKey.temperature }.first.map{ $0.1 as! Float }
                }
            }
        }
    }
    
    var serviceName : String? {
        didSet {
            if let _ = weatherView {
                setName(serviceName)
            }
        }
    }
    
    var temp : Float? {
        didSet {
            if let _ = weatherView {
                setTemperature(temp)
            }
        }
    }
    
    var humidity : Float? {
        didSet {
            if let _ = weatherView {
                setHumidity(humidity)
            }
        }
    }
    
    var pressure : Float? {
        didSet {
            if let _ = weatherView {
                setPressure(pressure)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherView!.loadingIndicator!.startAnimating()
        
        if let chars = characteristics {
            if !chars.isEmpty {
                print(">>>setCharacteristics: \(chars) for accessory: \((accessory!.name)!)")
                setCharacteristics()
                weatherView!.loadingIndicator!.stopAnimating()
            }
        }
    }
    
    // MARK: - Set Values in LightView
    
    func setCharacteristics() {
        setService(nil)
        setName(accessory?.name)
        setTemperature(temp)
        setHumidity(humidity)
        setPressure(pressure)
    }
    
    func setService(name: String?) {
        if let _ = serviceName {
            //            lightView!.infotext!.text = name
        } else {
            //            lightView!.infotext!.text = "Not Found"
        }
    }
    
    func setName(name: String?) {
        if let name = name {
            weatherView?.humidity?.text = name
        } else {
            weatherView?.humidity?.text = "Not Found"
        }
    }
    
    func setTemperature(value: Float?) {
        if let value = value {
            let roundedValue = roundToPlaces(Double(value), places: 1)
            weatherView?.temperature?.text = "\(roundedValue)°C"
        } else {
            weatherView?.temperature?.text = "temp?"
        }
    }
    
    func setHumidity(value: Float?) {
        if let value = value {
            weatherView?.humidity?.text = "\(Int(value))%"
        } else {
            weatherView?.humidity?.text = "humidity?"
        }
    }
    
    func setPressure(value: Float?) {
        if let value = value {
            weatherView?.pressure?.text = "\(value) mbar"
        } else {
            weatherView?.pressure?.text = "pressure?"
        }
    }

    // MARK: - RoundToPlaces func
    
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
}
