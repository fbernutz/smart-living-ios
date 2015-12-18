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
    var characteristicProperties : CharacteristicProperties { get set }
//    var characteristicBlock : (() -> ())? { get set }
    
    func canHandle(service: HMService) -> Bool
    func characteristicsForService(service: HMService, completionHandler: (CharacteristicProperties) -> () )
}


// MARK: - Lamp

class Lamp: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
//    var characteristicBlock : (() -> ())?
    lazy var characteristicProperties = CharacteristicProperties()
    var charPropertiesSet = false
    
    func canHandle(service: HMService) -> Bool {
        
        if service.serviceType == HMServiceTypeLightbulb {
            return true
        } else {
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: (CharacteristicProperties) -> () ) {
        
        for characteristic in service.characteristics {
            
            switch characteristic.characteristicType {
                
            case HMCharacteristicTypeBrightness:
                print("Brightness")
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    self.characteristicProperties.brightness = value as? Float
                    self.charPropertiesSet = true
                    completionHandler(self.characteristicProperties)
                })
                
            case HMCharacteristicTypePowerState:
                print("PowerState")
//                stateCharacteristic = characteristic
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    self.characteristicProperties.state = value as? Bool
                    self.charPropertiesSet = true
                    completionHandler(self.characteristicProperties)
                })
                
                /* hier noch weitere Characteristics abfragen */
            case HMCharacteristicTypeCurrentTemperature:
                print("Current Temperature")
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    self.characteristicProperties.temperature = value as? Float
                    self.charPropertiesSet = true
                    completionHandler(self.characteristicProperties)
                })
            case HMCharacteristicTypeCurrentRelativeHumidity:
                print("Current Humidity")
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    self.characteristicProperties.humidity = value as? Float
                    self.charPropertiesSet = true
                    completionHandler(self.characteristicProperties)
                })
            case HMCharacteristicTypeCurrentDoorState:
                print("Current Door State")
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    self.characteristicProperties.doorState = value as? Bool
                    self.charPropertiesSet = true
                    completionHandler(self.characteristicProperties)
                })
            default:
                print("default")
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    self.characteristicProperties.testVariableDefault = value
                    self.charPropertiesSet = true
                    completionHandler(self.characteristicProperties)
                })
                
                break
            }
            
        }
        
    }
    
    
    
}

// MARK: - Eve Weather

class WeatherStation: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    lazy var characteristicProperties = CharacteristicProperties()
    var characteristicBlock : (() -> ())?
    
    func canHandle(service: HMService) -> Bool {
        
        if service.serviceType == HMServiceTypeTemperatureSensor || service.serviceType == HMServiceTypeHumiditySensor {
            return true
        } else {
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: (CharacteristicProperties) -> () ) {
        let temperature: Float?   // in °C
        let humidity: Float?  // Luftfeuchtigkeit in %
        let airPressure: Float?   // Luftdruck in Pa
        
    }
    
}

// MARK: - Eve Energy

class EnergyController: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    lazy var characteristicProperties = CharacteristicProperties()
    var characteristicBlock : (() -> ())?
    
    func canHandle(service: HMService) -> Bool {
        
        if service.serviceType == HMServiceTypeSwitch {
            return true
        } else {
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: (CharacteristicProperties) -> () ) {
        let status: Bool?
        let powerConsumption: Float?
        
    }
    
}

// MARK: - Eve Door & Window

class DoorWindowSensor: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    lazy var characteristicProperties = CharacteristicProperties()
    var characteristicBlock : (() -> ())?
    
    func canHandle(service: HMService) -> Bool {
        
        switch service.serviceType {
        case "E863F007-079E-48FF-8F27-9C2605A29F52":
            return true
        default:
            return false
        }
        
    }
    
    func characteristicsForService(service: HMService, completionHandler: (CharacteristicProperties) -> () ) {
        
        for characteristic in service.characteristics {
            
            switch characteristic.characteristicType {
            case HMCharacteristicTypeCurrentDoorState:
                print("Current Door State")
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    self.characteristicProperties.doorState = value as? Bool
                    completionHandler(self.characteristicProperties)
                })
            default:
                print("default")
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    self.characteristicProperties.testVariableDefault = value
                    completionHandler(self.characteristicProperties)
                })
                
                break
            }
            
            
            //            if !homeKitCharacteristics!.contains(characteristic) {
            //                homeKitCharacteristics!.append(characteristic)
            //            }
            
            //            if !characteristics!.contains(characteristic.characteristicType) {
            //                characteristics!.append(characteristic.characteristicType)
            //            }
            
        }
        
        //        return characteristics
    }
    
}

// MARK: - Information

class Information: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    lazy var characteristicProperties = CharacteristicProperties()
    var characteristicBlock : (() -> ())?
    
    func canHandle(service: HMService) -> Bool {
        switch service.serviceType {
        case HMServiceTypeAccessoryInformation:
            return true
        default:
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: (CharacteristicProperties) -> () ) {
        //        return 0
        //        return nil
    }
    
}

// MARK: - Diverse

class Diverse: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    lazy var characteristicProperties = CharacteristicProperties()
    var characteristicBlock : (() -> ())?
    
    func canHandle(service: HMService) -> Bool {
        switch service.serviceType {
        case HMServiceTypeAccessoryInformation, HMServiceTypeHumiditySensor, HMServiceTypeLightbulb, HMServiceTypeSwitch, HMServiceTypeTemperatureSensor:
            return false
        default:
            return true
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: (CharacteristicProperties) -> () ) {
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
}