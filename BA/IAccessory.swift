//
//  IAccessory.swift
//  BA
//
//  Created by Felizia Bernutz on 30.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit
import HomeKit

let EveServiceType = "E863F007-079E-48FF-8F27-9C2605A29F52"
//3 Services von Eve in HomeKitApp
//00000043-0000-1000-8000-0026BB765291
//00000043-0000-1000-8000-0026BB765291
//E863F007-079E-48FF-8F27-9C2605A29F52

let EveCharacteristic1 = "E863F11C-079E-48FF-8F27-9C2605A29F52"
let EveCharacteristic2 = "E863F121-079E-48FF-8F27-9C2605A29F52"
let EveCharacteristic3 = "E863F116-079E-48FF-8F27-9C2605A29F52"
let EveCharacteristic4 = "E863F117-079E-48FF-8F27-9C2605A29F52"

//EVE ENERGY 3 service types
//0000003E-0000-1000-8000-0026BB765291 -> HMServiceTypeAccessoryInformation
//00000047-0000-1000-8000-0026BB765291 -> HMServiceTypeOutlet
//E863F007-079E-48FF-8F27-9C2605A29F52 -> siehe andere

//Characteristics für den 2. Service
//Eve Energy: E863F11E-079E-48FF-8F27-9C2605A29F52
//Eve Energy: E863F112-079E-48FF-8F27-9C2605A29F52
//Eve Energy: 00000025-0000-1000-8000-0026BB765291 // -> HMCharacteristicTypePowerState
//Eve Energy: 00000026-0000-1000-8000-0026BB765291 // -> HMCharacteristicTypeOutletInUse
//Eve Energy: E863F10A-079E-48FF-8F27-9C2605A29F52
//Eve Energy: E863F126-079E-48FF-8F27-9C2605A29F52
//Eve Energy: E863F10D-079E-48FF-8F27-9C2605A29F52
//Eve Energy: E863F110-079E-48FF-8F27-9C2605A29F52
//Eve Energy: E863F10C-079E-48FF-8F27-9C2605A29F52
//Eve Energy: E863F127-079E-48FF-8F27-9C2605A29F52
//Eve Energy: E863F10E-079E-48FF-8F27-9C2605A29F52

//EVE DOOR 3 service types
//0000003E-0000-1000-8000-0026BB765291 -> HMServiceTypeAccessoryInformation
//E863F003-079E-48FF-8F27-9C2605A29F52
//E863F007-079E-48FF-8F27-9C2605A29F52 -> siehe andere


//EVE WEATHER 3 service types
//0000003E-0000-1000-8000-0026BB765291 -> HMServiceTypeAccessoryInformation
//E863F001-079E-48FF-8F27-9C2605A29F52
//E863F007-079E-48FF-8F27-9C2605A29F52 -> siehe andere

//Characteristics
//Eve Weather: E863F11E-079E-48FF-8F27-9C2605A29F52
//Eve Weather: E863F112-079E-48FF-8F27-9C2605A29F52
//Eve Weather: E863F11B-079E-48FF-8F27-9C2605A29F52
//Eve Weather: 00000011-0000-1000-8000-0026BB765291 -> Temperatur
//Eve Weather: E863F111-079E-48FF-8F27-9C2605A29F52
//Eve Weather: E863F124-079E-48FF-8F27-9C2605A29F52
//Eve Weather: 00000010-0000-1000-8000-0026BB765291 -> Luftfeuchtigkeit
//Eve Weather: E863F12A-079E-48FF-8F27-9C2605A29F52
//Eve Weather: E863F12B-079E-48FF-8F27-9C2605A29F52
//Eve Weather: E863F10F-079E-48FF-8F27-9C2605A29F52

protocol IAccessory {
    var name : String? { get set }
    var uniqueID : NSUUID? { get set }
    var characteristics : [CharacteristicKey : AnyObject] { get set }
    var characteristicBlock : (() -> ())? { get set }
    
    func canHandle(service: HMService, name: String?) -> Bool
    func characteristicsForService(service: HMService, completionHandler: ([CharacteristicKey : AnyObject]) -> () )
}

// MARK: - Lamp

class Lamp: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    var characteristicBlock : (() -> ())?
    var characteristics = [CharacteristicKey : AnyObject]()
    
    func canHandle(service: HMService, name: String?) -> Bool {
        if service.serviceType == HMServiceTypeLightbulb {
            return true
        } else {
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([CharacteristicKey : AnyObject]) -> () ) {
        
        characteristics.removeAll()
        
        for characteristic in service.characteristics {
            
            if characteristic.characteristicType == (HMCharacteristicTypeName as String) {
                getCharacteristicValue(characteristic, completion: { value, error in
                    if let value = value {
                        self.characteristics[CharacteristicKey.serviceName] = value as! String
                        
                        if self.characteristics.count == service.characteristics.count {
                            completionHandler(self.characteristics)
                        }
                    }
                })
            }
            
            if characteristic.characteristicType == (HMCharacteristicTypeBrightness as String) {
                getCharacteristicValue(characteristic, completion: { value, error in
                    if let value = value {
                        self.characteristics[CharacteristicKey.brightness] = value as! Float
                        
                        if self.characteristics.count == service.characteristics.count {
                            completionHandler(self.characteristics)
                        }
                    }
                })
            }
            
            if characteristic.characteristicType == (HMCharacteristicTypePowerState as String) {
                getCharacteristicValue(characteristic, completion: { value, error in
                    if let value = value {
                        self.characteristics[CharacteristicKey.powerState] = value as! NSNumber
                        
                        if self.characteristics.count == service.characteristics.count {
                            completionHandler(self.characteristics)
                        }
                    }
                })
            }
            
        }
    }
}

// MARK: - Eve Weather

class WeatherStation: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    var characteristicBlock : (() -> ())?
    var characteristics = [CharacteristicKey : AnyObject]()
    var charCounter = 0
    
    func canHandle(service: HMService, name: String?) -> Bool {
        
        switch service.serviceType {
        case "E863F001-079E-48FF-8F27-9C2605A29F52":
            if name == "Eve Weather" {
                return true
            } else {
                return false
            }
            
        default:
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([CharacteristicKey : AnyObject]) -> () ) {
        
        characteristics.removeAll()
        
        for characteristic in service.characteristics {
            
//            print("Eve Weather: \(characteristic.characteristicType)")
            
            if characteristic.characteristicType == (HMCharacteristicTypeCurrentTemperature as String) {
                getCharacteristicValue(characteristic, completion: { value, error in
                    if let value = value {
                        self.charCounter++
                        
                        self.characteristics[CharacteristicKey.temperature] = value as! Float
                        if self.charCounter == 2 {
                            completionHandler(self.characteristics)
                        }
                    }
                })
            }
            
            if characteristic.characteristicType == (HMCharacteristicTypeCurrentRelativeHumidity as String) {
                getCharacteristicValue(characteristic, completion: { value, error in
                    if let value = value {
                        self.charCounter++
                        
                        self.characteristics[CharacteristicKey.humidity] = value as! Float
                        if self.charCounter == 2 {
                            completionHandler(self.characteristics)
                        }
                    }
                })
            }
            
            //TODO: read pressure
//            if characteristic.characteristicType == "E863F11B-079E-48FF-8F27-9C2605A29F52" {
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    if let value = value {
//                        self.characteristics[CharacteristicKey.pressure] = value as! Float
//                        if self.charCounter == 3 {
//                            completionHandler(self.characteristics)
//                        }
//                    }
//                })
//            }
            
        }

    }
    
}

// MARK: - Eve Energy

class EnergyController: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    var characteristics = [CharacteristicKey : AnyObject]()
    var characteristicBlock : (() -> ())?
    
    func canHandle(service: HMService, name: String?) -> Bool {
        switch service.serviceType {
        case HMServiceTypeOutlet:
            if name == "Eve Energy" {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([CharacteristicKey : AnyObject]) -> () ) {
        
        characteristics.removeAll()
        
        for characteristic in service.characteristics {
            
//            print("Eve Energy: \(characteristic.characteristicType)")
            
            if characteristic.characteristicType == (HMCharacteristicTypePowerState as String) {
                getCharacteristicValue(characteristic, completion: { value, error in
                    if let value = value {
                        self.characteristics[CharacteristicKey.powerState] = value as! Bool
                        completionHandler(self.characteristics)
                    }
                })
            }
        }
        
    }
    
}

// MARK: - Eve Door & Window

class DoorWindowSensor: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    var characteristicBlock : (() -> ())?
    var characteristics = [CharacteristicKey : AnyObject]()
    
    func canHandle(service: HMService, name: String?) -> Bool {
        
        switch service.serviceType {
            
        case "E863F003-079E-48FF-8F27-9C2605A29F52":
            if name == "Eve Door" {
                return true
            } else {
                return false
            }
        default:
            return false
        }
        
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([CharacteristicKey : AnyObject]) -> () ) {
        
        characteristics.removeAll()
        
        for characteristic in service.characteristics {
            
            print("Eve Door: \(characteristic.characteristicType)")
            
            if characteristic.characteristicType == (HMCharacteristicTypeCurrentDoorState as String) {
                getCharacteristicValue(characteristic, completion: { value, error in
                    if let value = value {
                        self.characteristics[CharacteristicKey.doorState] = value as! Bool
                        completionHandler(self.characteristics)
                    }
                })
            }
            
            //TODO: Door counter -> nicht über Char machen?
//            if characteristic.characteristicType == (HMCharacteristicTypeCurrentDoorState as String) {
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    if let value = value {
//                        self.characteristics[CharacteristicKey.doorCounter] = value as! Int
//                        completionHandler(self.characteristics)
//                    }
//                })
//            }
        }
    }
    
}

// MARK: - Information

class Information: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    var characteristicBlock : (() -> ())?
    
    var characteristics = [CharacteristicKey : AnyObject]()
    func canHandle(service: HMService, name: String?) -> Bool {
        switch service.serviceType {
        case HMServiceTypeAccessoryInformation:
            return true
        default:
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([CharacteristicKey : AnyObject]) -> () ) {
        for characteristic in service.characteristics {
            if characteristic.characteristicType == (HMCharacteristicTypeName as String) {
                getCharacteristicValue(characteristic, completion: { value, error in
                    if let value = value {
                        self.characteristics[CharacteristicKey.serviceName] = value as! String
                        
                        if self.characteristics.count == service.characteristics.count {
                            completionHandler(self.characteristics)
                        }
                    }
                })
            }
        }
    }
    
}

// MARK: - Diverse

class Diverse: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    var characteristicBlock : (() -> ())?
    
    var characteristics = [CharacteristicKey : AnyObject]()
    
    func canHandle(service: HMService, name: String?) -> Bool {
        print(service.serviceType)
        switch service.serviceType {
        case HMServiceTypeAccessoryInformation, HMServiceTypeHumiditySensor, HMServiceTypeLightbulb, HMServiceTypeSwitch, HMServiceTypeTemperatureSensor, HMServiceTypeOutlet:
            return false
        default:
            return true
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([CharacteristicKey : AnyObject]) -> () ) {
        //nothing
    }
    
}


// MARK: - Extension

extension HMCharacteristic {
    
    func containsProperty(paramProperty: String) -> Bool {
        for property in self.properties {
            if property == paramProperty {
                return true
            }
        }
        return false
    }
    
    func isReadable() -> Bool {
        return containsProperty(HMCharacteristicPropertyReadable)
    }
    
    func isWritable() -> Bool {
        return containsProperty(HMCharacteristicPropertyWritable)
    }
    
}

extension IAccessory {
    
    func getCharacteristicValue(characteristic: HMCharacteristic, completion: (AnyObject?, NSError?) -> () ) {
        if !characteristic.isReadable() {
            completion(nil, NSError(domain: "not readable", code: 1, userInfo: nil))
        } else {
            characteristic.readValueWithCompletionHandler { error in
                if error != nil {
                    completion(nil, error)
                } else {
                    if !characteristic.isWritable() {
                        completion(characteristic.value, NSError(domain: "not writable", code: 2, userInfo: nil))
                    } else {
                        characteristic.writeValue(characteristic.value, completionHandler: { error in
                            if error != nil {
                                completion(characteristic.value, error)
                            } else {
                                completion(characteristic.value, nil)
                            }
                            }
                        )
                    }
                }
            }
        }
    }
    
//    func setCharacteristic(characteristic: HMCharacteristic, value: AnyObject?){
//        
//        characteristic.writeValue(value, completionHandler: { error in
//            if let error = error {
//                NSLog("Failed to update value \(error)")
//            }
//        })
//        
////        self.characteristics[CharacteristicKey.doorState] = value as! Bool
//        
//    }
    
    
    mutating func retrieveCharacteristics(service: HMService) {
        
        characteristicsForService(service, completionHandler: { characteristics in
            print(self.name!, characteristics.count, service.characteristics.count)
            
//            if characteristics.count == service.characteristics.count {
                self.characteristics = characteristics
                
                if let block = self.characteristicBlock {
                    block()
                    self.characteristicBlock = nil
                }
//            }
        })
    }
    
    func getCharacteristics() -> [CharacteristicKey:AnyObject]? {
        if !characteristics.isEmpty {
            return characteristics
        } else {
            return nil
        }
    }

}