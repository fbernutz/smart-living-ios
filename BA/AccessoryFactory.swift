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
    
    var localAccessories : [IAccessory]?
    var accessories : [HMAccessory]?
    var arrayOfTypes: [IAccessory] = [Lamp(), WeatherStation(), EnergyController(), DoorWindowSensor()]
    
    
    func accessoryForServices(service: HMService) -> IAccessory? {
        let array = arrayOfTypes.filter { $0.canHandle(service) }
        return array.first
    }
    
    
//    func serviceForAccessory(accessory: IAccessory) -> HMService? {
//    // sucht nach verfügbaren Services für die Accessories
//        for accessory in localAccessories! {
//            
//        }
//        return nil
//    }
    
}


