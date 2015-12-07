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
    var arrayOfTypes: [IAccessory] = [Lamp(), WeatherStation(), EnergyController(), DoorWindowSensor(), Diverse()]
    
    var name : String?
    var uniqueID : NSUUID?
    
    func accessoryForServices(service: HMService) -> IAccessory? {
        let canHandleServiceAccessory = arrayOfTypes.filter { $0.canHandle(service) }.first
        return canHandleServiceAccessory
    }
    
    func setIAccessory(accessoryName: String, accessoryID: NSUUID) {
        name = accessoryName
        uniqueID = accessoryID
    }
    
    
//    func serviceForAccessory(accessory: IAccessory) -> HMService? {
//    // sucht nach verfügbaren Services für die Accessories
//        for accessory in localAccessories! {
//            
//        }
//        return nil
//    }
    
}


