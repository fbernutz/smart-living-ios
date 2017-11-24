//
//  AccessoryItem.swift
//  BA
//
//  Created by Felizia Bernutz on 30.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit
import HomeKit

let eveEnergy = HMServiceTypeOutlet
let eveWeather = "E863F001-079E-48FF-8F27-9C2605A29F52"
let eveDoorAndWindow = "E863F003-079E-48FF-8F27-9C2605A29F52"

protocol AccessoryItem {
    var name: String? { get set }
    var uniqueID: UUID? { get set }
    var reachable: Bool? { get set }
    var characteristics: [CharacteristicKey : AnyObject] { get set }
    var characteristicBlock : (() -> Void)? { get set }

    func canHandle(_ service: HMService, name: String?) -> Bool
    func characteristicsForService(_ service: HMService, completionHandler: @escaping ([CharacteristicKey : AnyObject]) -> Void )
}

// MARK: - Lamp

class Lamp: AccessoryItem {

    var name: String?
    var uniqueID: UUID?
    var reachable: Bool?
    var characteristics = [CharacteristicKey: AnyObject]()
    var characteristicBlock : (() -> Void)?

    func canHandle(_ service: HMService, name: String?) -> Bool {
        if service.serviceType == HMServiceTypeLightbulb {
            return true
        } else {
            return false
        }
    }

    func characteristicsForService(_ service: HMService, completionHandler: @escaping ([CharacteristicKey : AnyObject]) -> Void ) {

        characteristics.removeAll()

        for characteristic in service.characteristics {

            if characteristic.characteristicType == (HMCharacteristicTypeName as String) {
                getCharacteristicValue(characteristic, completion: { value, _ in
                    if let value = value {
                        self.characteristics[CharacteristicKey.serviceName] = value as! String as AnyObject?

                        if self.characteristics.count == service.characteristics.count {
                            completionHandler(self.characteristics)
                        }
                    }
                })
            }

            if characteristic.characteristicType == (HMCharacteristicTypeBrightness as String) {
                getCharacteristicValue(characteristic, completion: { value, _ in
                    if let value = value {
                        self.characteristics[CharacteristicKey.brightness] = value as! Float as AnyObject?

                        if self.characteristics.count == service.characteristics.count {
                            completionHandler(self.characteristics)
                        }
                    }
                })
            }

            if characteristic.characteristicType == (HMCharacteristicTypePowerState as String) {
                getCharacteristicValue(characteristic, completion: { value, _ in
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

class WeatherStation: AccessoryItem {

    var name: String?
    var uniqueID: UUID?
    var reachable: Bool?
    var characteristics = [CharacteristicKey: AnyObject]()
    var characteristicBlock : (() -> Void)?
    var charCounter = 0

    func canHandle(_ service: HMService, name: String?) -> Bool {

        switch service.serviceType {
        case eveWeather:
            if name == "Eve Weather" {
                return true
            } else {
                return false
            }

        default:
            return false
        }
    }

    func characteristicsForService(_ service: HMService, completionHandler: @escaping ([CharacteristicKey : AnyObject]) -> Void ) {

        characteristics.removeAll()
        charCounter = 0

        for characteristic in service.characteristics {

            if characteristic.characteristicType == (HMCharacteristicTypeCurrentTemperature as String) {
                getCharacteristicValue(characteristic, completion: { value, _ in
                    if let value = value {
                        self.charCounter += 1

                        self.characteristics[CharacteristicKey.temperature] = value as! Float as AnyObject?
                        if self.charCounter == 2 {
                            completionHandler(self.characteristics)
                        }
                    }
                })
            }

            if characteristic.characteristicType == (HMCharacteristicTypeCurrentRelativeHumidity as String) {
                getCharacteristicValue(characteristic, completion: { value, _ in
                    if let value = value {
                        self.charCounter += 1

                        self.characteristics[CharacteristicKey.humidity] = value as! Float as AnyObject?
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

class EnergyController: AccessoryItem {

    var name: String?
    var uniqueID: UUID?
    var reachable: Bool?
    var characteristics = [CharacteristicKey: AnyObject]()
    var characteristicBlock : (() -> Void)?

    func canHandle(_ service: HMService, name: String?) -> Bool {
        switch service.serviceType {
        case eveEnergy:
            if name == "Eve Energy" {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }

    func characteristicsForService(_ service: HMService, completionHandler: @escaping ([CharacteristicKey : AnyObject]) -> Void ) {

        characteristics.removeAll()

        for characteristic in service.characteristics {

            if characteristic.characteristicType == (HMCharacteristicTypePowerState as String) {
                getCharacteristicValue(characteristic, completion: { value, _ in
                    if let value = value {
                        self.characteristics[CharacteristicKey.powerState] = value as! Bool as AnyObject?
                        completionHandler(self.characteristics)
                    }
                })
            }
        }
    }

}

// MARK: - Eve Door & Window

class DoorWindowSensor: AccessoryItem {

    var name: String?
    var uniqueID: UUID?
    var reachable: Bool?
    var characteristics = [CharacteristicKey: AnyObject]()
    var characteristicBlock : (() -> Void)?

    func canHandle(_ service: HMService, name: String?) -> Bool {

        switch service.serviceType {

        case eveDoorAndWindow:
            if name == "Eve Door" {
                return true
            } else {
                return false
            }
        default:
            return false
        }

    }

    func characteristicsForService(_ service: HMService, completionHandler: @escaping ([CharacteristicKey : AnyObject]) -> Void ) {

        characteristics.removeAll()

        for characteristic in service.characteristics {

            if characteristic.characteristicType == (HMCharacteristicTypeCurrentDoorState as String) {
                getCharacteristicValue(characteristic, completion: { value, _ in
                    if let value = value {
                        self.characteristics[CharacteristicKey.doorState] = value as! Bool as AnyObject?
                        completionHandler(self.characteristics)
                    }
                })
            }

        }
    }

}

// MARK: - Information

class Information: AccessoryItem {

    var name: String?
    var uniqueID: UUID?
    var reachable: Bool?
    var characteristics = [CharacteristicKey: AnyObject]()
    var characteristicBlock : (() -> Void)?

    func canHandle(_ service: HMService, name: String?) -> Bool {
        switch service.serviceType {
        case HMServiceTypeAccessoryInformation:
            return true
        default:
            return false
        }
    }

    func characteristicsForService(_ service: HMService, completionHandler: @escaping ([CharacteristicKey : AnyObject]) -> Void ) {

        characteristics.removeAll()

        for characteristic in service.characteristics {

            if characteristic.characteristicType == (HMCharacteristicTypeName as String) {
                getCharacteristicValue(characteristic, completion: { value, _ in
                    if let value = value {
                        self.characteristics[CharacteristicKey.serviceName] = value as! String as AnyObject?

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

class Diverse: AccessoryItem {

    var name: String?
    var uniqueID: UUID?
    var reachable: Bool?
    var characteristics = [CharacteristicKey: AnyObject]()
    var characteristicBlock : (() -> Void)?

    func canHandle(_ service: HMService, name: String?) -> Bool {
        switch service.serviceType {
        case HMServiceTypeAccessoryInformation, HMServiceTypeHumiditySensor, HMServiceTypeLightbulb, HMServiceTypeSwitch, HMServiceTypeTemperatureSensor, HMServiceTypeOutlet:
            return false
        default:
            return true
        }
    }

    func characteristicsForService(_ service: HMService, completionHandler: @escaping ([CharacteristicKey : AnyObject]) -> Void ) {
        characteristics.removeAll()
        characteristics[CharacteristicKey.serviceName] = service.name as AnyObject?
        completionHandler(self.characteristics)
    }

}

// MARK: - Extension

extension HMCharacteristic {

    func containsProperty(_ paramProperty: String) -> Bool {
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

    func supportsEventNotification() -> Bool {
        return containsProperty(NSNotification.Name.HMCharacteristicPropertySupportsEvent.rawValue)
    }

}

extension AccessoryItem {

    func getCharacteristicValue(_ characteristic: HMCharacteristic, completion: @escaping (AnyObject?, NSError?) -> Void ) {
        if !characteristic.isReadable() {
            completion(nil, NSError(domain: "not readable", code: 1, userInfo: nil))
        } else {
            characteristic.readValue { error in
                if error != nil {
                    completion(nil, error as NSError?)
                } else {
                    if !characteristic.isWritable() {
                        completion(characteristic.value as AnyObject?, NSError(domain: "not writable", code: 2, userInfo: nil))
                    } else {
                        characteristic.writeValue(characteristic.value, completionHandler: { error in
                            if error != nil {
                                completion(characteristic.value as AnyObject?, error as NSError?)
                            } else {
                                completion(characteristic.value as AnyObject?, nil)
                            }
                            }
                        )
                    }
                }
            }
        }
    }

    mutating func retrieveCharacteristics(_ service: HMService) {

        characteristicsForService(service, completionHandler: { _ in
//            print("\(self.name!): \(characteristics.count) von \(service.characteristics.count) Chars")

            //FIXME: 
//            if characteristics.count == service.characteristics.count {
//                self.characteristics = characteristics
//
//                if let block = self.characteristicBlock {
//                    block()
//                    self.characteristicBlock = nil
//                }
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
