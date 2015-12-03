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

// MARK: - Lamp

class Lamp: IAccessory {
    
    var uniqueID : NSUUID?
    var name : String = "Lamp"
    
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
    var name : String = "Weather Station"
    
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
    var name : String = "Energy Controller"
    
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
    var name : String = "DoorWindow Sensor"
    
     func canHandle(service: HMService) -> Bool {
        
        // TODO: überprüfen welcher Service, der richtige ist
        if service.serviceType == HMServiceTypeWindow {
            return true
        } else {
            return false
        }
    }
    
}

