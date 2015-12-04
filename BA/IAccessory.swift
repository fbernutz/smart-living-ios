//
//  IAccessory.swift
//  BA
//
//  Created by Felizia Bernutz on 30.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import Foundation
import HomeKit

protocol IAccessory {
    func canHandle(service: HMService) -> Bool
    // TODO: func die entscheidet, welche Characteristic sie hat
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
    
    var uniqueID : NSUUID?
    var name : String?
    
    func canHandle(service: HMService) -> Bool {
        
        if service.serviceType == HMServiceTypeLightbulb {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - Eve Weather

class WeatherStation: IAccessory {
    
    var uniqueID : NSUUID?
    var name : String?
    
    func canHandle(service: HMService) -> Bool {
        
        if service.serviceType == HMServiceTypeTemperatureSensor {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - Eve Energy

class EnergyController: IAccessory {
    
    var uniqueID : NSUUID?
    var name : String?
    
    func canHandle(service: HMService) -> Bool {
        
        if service.serviceType == HMServiceTypeSwitch {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - Eve Door & Window

class DoorWindowSensor: IAccessory {
    
    var uniqueID : NSUUID?
    var name : String?
    
    func canHandle(service: HMService) -> Bool {
        
        // TODO: überprüfen welcher Service, der richtige ist
        if service.serviceType == HMServiceTypeWindow {
            return true
        } else {
            return false
        }
    }
    
}


// MARK: - Diverse

class Diverse: IAccessory {
    
    var uniqueID : NSUUID?
    var name : String?
    
    func canHandle(service: HMService) -> Bool {
        
        switch service.serviceType {
        case HMServiceTypeWindow, HMServiceTypeWindow, HMServiceTypeSwitch, HMServiceTypeTemperatureSensor, HMServiceTypeLightbulb:
            return false
        default:
            return true
        }
    }
    
}

