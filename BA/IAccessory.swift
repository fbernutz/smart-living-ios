//
//  IAccessory.swift
//  BA
//
//  Created by Felizia Bernutz on 30.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit
import HomeKit

protocol IAccessory {
    var name : String? { get set }
    var uniqueID : NSUUID? { get set }
    
    func canHandle(service: HMService) -> Bool
    func characteristicForService() -> Int
}


func findServicesForAccessory(accessory: HMAccessory) -> HMService? {
    if (accessory.services.count != 0) { //mehr Services als der eine Information Service
        for service in accessory.services {
            return service
        }
    } else {
        print("has no services")
    }
    return nil
}

func findCharacteristicsOfService(service: HMService){
    //    characteristics.removeAll(keepCapacity: true)
    for characteristic in service.characteristics {
        
        //        if characteristic.characteristicType == (HMCharacteristicTypeBrightness as String) {
        //            brightnessCharacteristic = characteristic
        //            enableBrightnessView()
        //        }
        //        //..
        //        if !characteristics.contains(characteristic) {
        //            characteristics.append(characteristic)
        //        }
    }
}



// MARK: - Lamp

class Lamp: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    
    func canHandle(service: HMService) -> Bool {
        
        if service.serviceType == HMServiceTypeLightbulb {
            return true
        } else {
            return false
        }
    }
    
    
    func characteristicForService() -> Int {
        let status: Bool?
        let brightness: Int?
        let color: UIColor?
//        var array = [status: true, brightness: 10, color: UIColor.whiteColor()]
        
        return 3
    }
    
}

// MARK: - Eve Weather

class WeatherStation: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    
    func canHandle(service: HMService) -> Bool {
        
        if service.serviceType == HMServiceTypeTemperatureSensor {
            return true
        } else {
            return false
        }
    }
    
    func characteristicForService() -> Int {
        let temperature: Float?   // in °C
        let humidity: Float?  // Luftfeuchtigkeit in %
        let airPressure: Float?   // Luftdruck in Pa
        
        return 3
    }
    
}

// MARK: - Eve Energy

class EnergyController: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    
    func canHandle(service: HMService) -> Bool {
        
        if service.serviceType == HMServiceTypeSwitch {
            return true
        } else {
            return false
        }
    }
    
    func characteristicForService() -> Int {
        let status: Bool?
        let powerConsumption: Float?
        
        return 2
    }
    
}

// MARK: - Eve Door & Window

class DoorWindowSensor: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    
    func canHandle(service: HMService) -> Bool {
        
        // TODO: überprüfen welcher Service, der richtige ist
        if service.serviceType == HMServiceTypeWindow {
            return true
        } else {
            return false
        }
    }
    
    func characteristicForService() -> Int {
        let status: Bool?
        let counter: Int?
        
        return 2
    }
    
}


// MARK: - Diverse

class Diverse: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    
    func canHandle(service: HMService) -> Bool {
        
        switch service.serviceType {
        case HMServiceTypeWindow, HMServiceTypeWindow, HMServiceTypeSwitch, HMServiceTypeTemperatureSensor, HMServiceTypeLightbulb:
            return false
        default:
            return true
        }
    }
    
    func characteristicForService() -> Int {
        //nothing
        return 0
    }
    
}

