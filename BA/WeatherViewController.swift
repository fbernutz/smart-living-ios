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
    
    var accessory : AccessoryItem? {
        didSet {
            if accessory?.characteristics != nil {
                characteristics = accessory!.characteristics
            }
            
            reachable = accessory?.reachable
        }
    }
    
    var characteristics : [CharacteristicKey:AnyObject]? {
        didSet {
            if let chars = characteristics {
                if !chars.isEmpty {
                    serviceName = chars.filter{ $0.0 == CharacteristicKey.serviceName }.first.map{ $0.1 as! String }
                    pressure = chars.filter{ $0.0 == CharacteristicKey.pressure }.first.map{ $0.1 as! Float }
                    humidity = chars.filter{ $0.0 == CharacteristicKey.humidity }.first.map{ $0.1 as! Float }
                    temp = chars.filter{ $0.0 == CharacteristicKey.temperature }.first.map{ $0.1 as! Float }
                }
            }
        }
    }
    
    var reachable : Bool?
    
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
    
    var size : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let reachable = reachable {
            if reachable {
                if let chars = characteristics {
                    if !chars.isEmpty {
                        print(">>>setCharacteristics: \(chars) for accessory: \((accessory!.name)!)")
                        setCharacteristics()
                    }
                }
            } else {
                setName("Momentan nicht erreichbar")
            }
            
            let _ = contextHandler!.homeKitController!.completedAccessoryView(accessory!)
        }
        
        size = weatherView!.cView!.frame.size.height
    }
    
    // MARK: - Set Values in LightView
    
    func setCharacteristics() {
        setService(nil)
        setName(accessory?.name)
        setTemperature(temp)
        setHumidity(humidity)
        setPressure(1018)
//        setPressure(pressure)
    }
    
    func setService(_ name: String?) {
        if let _ = serviceName {
            //            lightView!.infotext!.text = name
        } else {
            //            lightView!.infotext!.text = "Not Found"
        }
    }
    
    func setName(_ name: String?) {
        if let name = name {
            weatherView?.name?.isHidden = false
            weatherView?.name?.text = name
        } else {
            weatherView?.name?.isHidden = true
        }
    }
    
    func setTemperature(_ value: Float?) {
        if let value = value {
            weatherView?.temperature?.isHidden = false
            let roundedValue = roundToPlaces(Double(value), places: 1)
            weatherView?.temperature?.text = "\(roundedValue) °C"
        } else {
            weatherView?.temperature?.isHidden = true
        }
    }
    
    func setHumidity(_ value: Float?) {
        if let value = value {
            weatherView?.humidity?.isHidden = false
            weatherView?.humidity?.text = "Luftfeuchtigkeit: \(value) %"
        } else {
            weatherView?.humidity?.isHidden = true
        }
    }
    
    func setPressure(_ value: Float?) {
        if let value = value {
            weatherView?.pressure?.isHidden = false
            weatherView?.pressure?.text = "Luftdruck: \(value) hPa"
        } else {
            weatherView?.pressure?.isHidden = true
        }
    }

    // MARK: - RoundToPlaces func
    
    func roundToPlaces(_ value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
}
