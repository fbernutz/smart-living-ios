//
//  AccessoryFactory.swift
//  BA
//
//  Created by Felizia Bernutz on 30.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import Foundation
import HomeKit

class AccessoryFactory {
    
    var accessories : [HMAccessory]?
    
    var lampService = Lamp()
    var weatherStationService = WeatherStation()
    var energyControllerService = EnergyController()
    var doorWindowSensorService = DoorWindowSensor()
    var informationService = Information()
    var diverseService = Diverse()
    
    var arrayOfTypes: [AccessoryItem]?
    
    func accessoryForServices(_ service: HMService, name: String?) -> AccessoryItem? {
        arrayOfTypes = [lampService, weatherStationService, energyControllerService, doorWindowSensorService, informationService, diverseService]
        
        let canHandleServiceAccessory = arrayOfTypes!.filter{ $0.canHandle(service, name: name) }.first
        
        //create a new instance of this type
        switch canHandleServiceAccessory {
        case is Lamp:
            return Lamp()
        case is WeatherStation:
            return WeatherStation()
        case is EnergyController:
            return EnergyController()
        case is DoorWindowSensor:
            return DoorWindowSensor()
        case is Information:
            return Information()
        case is Diverse:
            return Diverse()
        default: return nil
        }
    }
    
}


