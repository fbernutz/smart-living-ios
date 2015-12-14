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
    
//    var state: Bool? {
//        didSet {
//            if state == true {
//                //                    self.sliderLabel.enabled = true
//                //                    self.SliderBtn.enabled = true
//                //
//                //                    self.SwitchBtn.setOn(true, animated: true)
//                //                    self.switchLabel.text = "On"
//            } else {
//                //                    self.sliderLabel.enabled = false
//                //                    self.SliderBtn.enabled = false
//                //
//                //                    self.SwitchBtn.setOn(false, animated: true)
//                //                    self.switchLabel.text = "Off"
//            }
//        }
//    }
//    var brightness: Float? {
//        didSet {
//            //                self.SliderBtn.setValue(newValue!, animated: true)
//            //                self.sliderLabel.text = "\(Int(newValue!))"
//        }
//    }
//    var color: UIColor?
    
//    var homeKitCharacteristics: [HMCharacteristic]? = []
//    
//    var brightnessCharacteristic : HMCharacteristic?
//    var stateCharacteristic : HMCharacteristic?
    
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
                
            default:
                print("default")
                
                getCharacteristicValue(characteristic, completion: { value, error in
                    self.characteristicProperties.testVariableDefault = value
                    self.charPropertiesSet = true
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
//    
//    func getBrightnessValue(characteristic: HMCharacteristic, completion: (AnyObject?, NSError?) -> Void) {
//        if characteristic.isReadable() == false {
//            print("Cannot read the value of the brightness characteristic")
//        } else {
//            characteristic.readValueWithCompletionHandler { error in
//                if error != nil {
//                    NSLog("Error read brightness characteristic value. \(error)")
//                } else {
//                    completion(characteristic.value, nil)
//                    
//                    self.brightness = characteristic.value as? Float
//                    
//                    
//                    if let block = self.characteristicBlock {
//                        block()
//                        self.characteristicBlock = nil
//                    }
//                    
//                    if characteristic.isWritable() == false {
//                        print("Cannot write the value of the brightness characteristic")
//                    } else {
//                        characteristic.writeValue(self.brightness, completionHandler:
//                            { error in
//                                if error != nil {
//                                    NSLog("Failed to update brightness \(error)")
//                                }
//                            }
//                        )
//                    }
//                }
//            }
//            
//        }
//    }
//    
//    func getStateValue(characteristic: HMCharacteristic) {
//        if characteristic.isReadable() == false {
//            print("Cannot read the value of the brightness characteristic")
//        } else {
//            characteristic.readValueWithCompletionHandler(
//                { error in
//                    if error != nil {
//                        NSLog("Error read brightness characteristic value. \(error)")
//                    } else {
//                        self.state = characteristic.value as? Bool
//                        
//                        //
//                        
//                        if characteristic.isWritable() == false {
//                            print("Cannot write the value of the brightness characteristic")
//                        } else {
//                            characteristic.writeValue(self.state, completionHandler:
//                                { error in
//                                    if error != nil {
//                                        NSLog("Failed to update brightness \(error)")
//                                    }
//                                }
//                            )
//                        }
//                    }
//                }
//            )
//        }
//    }
    
}

// MARK: - Eve Weather

class WeatherStation: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    lazy var characteristicProperties = CharacteristicProperties()
    var characteristicBlock : (() -> ())?
    
    func canHandle(service: HMService) -> Bool {
        
        if service.serviceType == HMServiceTypeTemperatureSensor {
            return true
        } else {
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: (CharacteristicProperties) -> () ) {
        let temperature: Float?   // in °C
        let humidity: Float?  // Luftfeuchtigkeit in %
        let airPressure: Float?   // Luftdruck in Pa
        
        //        return 3
        //        return nil
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
        
        //        return 2
        //        return nil
    }
    
}

// MARK: - Eve Door & Window

class DoorWindowSensor: IAccessory {
    
    var name : String?
    var uniqueID : NSUUID?
    lazy var characteristicProperties = CharacteristicProperties()
    var characteristicBlock : (() -> ())?
    
    func canHandle(service: HMService) -> Bool {
        
        // TODO: überprüfen welcher Service, der richtige ist
        if service.serviceType == HMServiceTypeWindow || service.serviceType == HMServiceTypeDoor {
            return true
        } else {
            return false
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: (CharacteristicProperties) -> () ) {
        let status: Bool?
        let counter: Int?
        
        //        return 2
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
        case HMServiceTypeWindow, HMServiceTypeWindow, HMServiceTypeSwitch, HMServiceTypeTemperatureSensor, HMServiceTypeLightbulb:
            return false
        default:
            return true
        }
    }
    
    func characteristicsForService(service: HMService, completionHandler: (CharacteristicProperties) -> () ) {
        //nothing
        //        return 0
        //        return nil
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