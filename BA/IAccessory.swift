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

let EveCharacteristic1 = "E863F11C-079E-48FF-8F27-9C2605A29F52"
let EveCharacteristic2 = "E863F121-079E-48FF-8F27-9C2605A29F52"
let EveCharacteristic3 = "E863F116-079E-48FF-8F27-9C2605A29F52"
let EveCharacteristic4 = "E863F117-079E-48FF-8F27-9C2605A29F52"


protocol IAccessory {
    var name : String? { get set }
    var uniqueID : NSUUID? { get set }
    var characteristics : [String : AnyObject] { get set }
    var characteristicBlock : (() -> ())? { get set }
    
    func canHandle(service: HMService, name: String?) -> Bool
    func characteristicsForService(service: HMService, completionHandler: ([String : AnyObject]) -> () )
}

// MARK: - Lamp

class Lamp: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    var characteristicBlock : (() -> ())?
    var characteristics = [String : AnyObject]()
    
    func canHandle(service: HMService, name: String?) -> Bool {
        if service.serviceType == HMServiceTypeLightbulb {
            return true
        } else {
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([String : AnyObject]) -> () ) {
        
        characteristics.removeAll(keepCapacity: false)
        
        for characteristic in service.characteristics {
            
            if characteristic.characteristicType == (HMCharacteristicTypeName as String) {
                print("new Name")
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    if let value = value {
                        self.characteristics["name"] = value as! String
                        print(self.characteristics)
                        completionHandler(self.characteristics)
                    }
                })
            }
            
            if characteristic.characteristicType == (HMCharacteristicTypeBrightness as String) {
                print("new Brightness")
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    if let value = value {
                        self.characteristics["brightness"] = value as! Float
                        print(self.characteristics)
                        completionHandler(self.characteristics)
                    }
                })
            }
            
            if characteristic.characteristicType == (HMCharacteristicTypePowerState as String) {
                print("new State")
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    if let value = value {
                        self.characteristics["powerState"] = value as! NSNumber
                        print(self.characteristics)
                        completionHandler(self.characteristics)
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
    
    var characteristics = [String : AnyObject]()
    
    func canHandle(service: HMService, name: String?) -> Bool {
        
        switch service.serviceType {
        case EveServiceType:
            if name == "Eve Weather" {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([String : AnyObject]) -> () ) {
//        let temperature: Float?   // in °C
//        let humidity: Float?  // Luftfeuchtigkeit in %
//        let airPressure: Float?   // Luftdruck in Pa
        
//        for characteristic in service.characteristics {
//            
//            switch characteristic.characteristicType {
//                
//            case HMCharacteristicTypeCurrentTemperature:
//                print("Current Temperature")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.temperature = value as? Float
//                    completionHandler(self.characteristicProperties)
//                })
//                
//            case HMCharacteristicTypeCurrentRelativeHumidity:
//                print("Current Humidity")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.humidity = value as? Float
//                    completionHandler(self.characteristicProperties)
//                })
//                
//            default:
//                print("default")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.testVariableDefault = value
//                    completionHandler(self.characteristicProperties)
//                })
//                
//                break
//            }
//            
//        }

    }
    
}

// MARK: - Eve Energy

class EnergyController: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    var characteristics = [String : AnyObject]()
    var characteristicBlock : (() -> ())?
    
    func canHandle(service: HMService, name: String?) -> Bool {
        switch service.serviceType {
        case EveServiceType:
            if name == "Eve Energy" {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([String : AnyObject]) -> () ) {

//        for characteristic in service.characteristics {
//            
////            print("Eve Energy: \(characteristic.characteristicType)")
//            
//            switch characteristic.characteristicType {
//            case EveCharacteristic1:
//                print("Eve Energy 1")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    if value != nil {
//                        self.characteristicProperties.name = value as? String
//                        completionHandler(self.characteristicProperties)
//                    }
//                })
//                
//            case EveCharacteristic2:
//                print("Eve Energy 2")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.state = value as? Bool
//                    completionHandler(self.characteristicProperties)
//                })
//                
//            case EveCharacteristic3:
//                print("Eve Energy 3")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.state = value as? Bool
//                    completionHandler(self.characteristicProperties)
//                })
//                
//            case EveCharacteristic4:
//                print("Eve Energy 4")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.state = value as? Bool
//                    completionHandler(self.characteristicProperties)
//                })
//                
//            case HMCharacteristicTypePowerState:
//                print("Eve Energy Current State")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.state = value as? Bool
//                    completionHandler(self.characteristicProperties)
//                })
//                
//            default:
//                print("default")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.testVariableDefault = value as? String
//                    completionHandler(self.characteristicProperties)
//                })
//                
//                break
//            }
//            
//        }
        
    }
    
}

// MARK: - Eve Door & Window

class DoorWindowSensor: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    var characteristicBlock : (() -> ())?
    
    var characteristics = [String : AnyObject]()
    func canHandle(service: HMService, name: String?) -> Bool {
        switch service.serviceType {
        case EveServiceType:
            if name == "Eve Door" {
                return true
            } else {
                return false
            }
        default:
            return false
        }
        
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([String : AnyObject]) -> () ) {
        
//        for characteristic in service.characteristics {
//            
////            print("Eve Door: \(characteristic.characteristicType)")
//            
//            switch characteristic.characteristicType {
//            case HMCharacteristicTypeCurrentDoorState:
//                print("Current Door State")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.doorState = value as? Bool
//                    completionHandler(self.characteristicProperties)
//                })
//                
//            default:
//                print("default")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.testVariableDefault = value
//                    completionHandler(self.characteristicProperties)
//                })
//                
//                break
//            }
//        }
    }
    
}

// MARK: - Information

class Information: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    var characteristicBlock : (() -> ())?
    
    var characteristics = [String : AnyObject]()
    func canHandle(service: HMService, name: String?) -> Bool {
        switch service.serviceType {
        case HMServiceTypeAccessoryInformation:
            return true
        default:
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([String : AnyObject]) -> () ) {
//        for characteristic in service.characteristics {
//            
//            switch characteristic.characteristicType {
//            case HMCharacteristicTypeName:
//                print("Current Name")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.name = value as? String
//                    completionHandler(self.characteristicProperties)
//                })
//                
//            default:
//                print("default")
//                
//                getCharacteristicValue(characteristic, completion: { value, error in
//                    self.characteristicProperties.testVariableDefault = value
//                    completionHandler(self.characteristicProperties)
//                })
//                
//                break
//            }
//        }
    }
    
}

// MARK: - Diverse

class Diverse: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    var characteristicBlock : (() -> ())?
    
    var characteristics = [String : AnyObject]()
    
    func canHandle(service: HMService, name: String?) -> Bool {
        switch service.serviceType {
        case HMServiceTypeAccessoryInformation, HMServiceTypeHumiditySensor, HMServiceTypeLightbulb, HMServiceTypeSwitch, HMServiceTypeTemperatureSensor:
            return false
        default:
            return true
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: ([String : AnyObject]) -> () ) {
        //nothing
//        completionHandler(characteristicProperties)
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
    
    mutating func retrieveCharacteristics(service: HMService) {
        
        characteristicsForService(service, completionHandler: { characteristics in
            print(characteristics.count, service.characteristics.count)
            
            if characteristics.count == service.characteristics.count {
                self.characteristics = characteristics
                
                if let block = self.characteristicBlock {
                    block()
                    self.characteristicBlock = nil
                }
            }
        })
    }
    
    func getCharacteristics() -> [String:AnyObject]? {
        if !characteristics.isEmpty {
            print(characteristics)
            return characteristics
        } else {
            return nil
        }
    }

}