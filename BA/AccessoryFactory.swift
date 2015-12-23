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
    
    var lampService = Lamp()
    var weatherStationService = WeatherStation()
    var energyControllerService = EnergyController()
    var doorWindowSensorService = DoorWindowSensor()
    var information = Information()
    var diverse = Diverse()
    
    var arrayOfTypes: [IAccessory]?
    
    
    func accessoryForServices(service: HMService, name: String?) -> IAccessory? {
        arrayOfTypes = [lampService, weatherStationService, energyControllerService, doorWindowSensorService, information, diverse]
        
        let canHandleServiceAccessory = arrayOfTypes!.filter { $0.canHandle(service, name: name) }.first
        
//        canHandleServiceAccessory?.characteristicsForService(service, completionHandler: { characteristicProperties -> () in
//            canHandleServiceAccessory?.characteristicProperties = characteristicProperties
//        })
        
        //new instance of type
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
    
    func characteristicForService(accessory: IAccessory, service: HMService, completionHandler: (CharacteristicProperties) -> () ) {
        accessory.characteristicsForService(service, completionHandler: completionHandler)
    }
    
//    func serviceForAccessory(accessory: IAccessory) -> HMService? {
//    // sucht nach verfügbaren Services für die Accessories
//        for accessory in localAccessories! {
//            
//        }
//        return nil
//    }
    
}


