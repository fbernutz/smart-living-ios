//
//  ContextHandler.swift
//  BA
//
//  Created by Felizia Bernutz on 18.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit
import HomeKit

class ContextHandler: NSObject, HMHomeManagerDelegate, BeaconControllerDelegate {

    var accessoryStoryboard: UIStoryboard?
    var homeKitController: HomeKitController?

    var homeID: UUID?

    var roomID: UUID? {
        didSet {
            //register notification
            let center = NotificationCenter.default
            let notification = Notification(name: Notification.Name(rawValue: "roomID"), object: self, userInfo: ["roomID": roomID!])
            center.post(notification)
        }
    }

    var localHomes: [Home]? {
        didSet {
            //register notification
            let center = NotificationCenter.default
            let notification = Notification(name: Notification.Name(rawValue: "localHomes"), object: self, userInfo: ["localHomes": localHomes!])
            center.post(notification)
        }
    }

    var localRooms: [Room]? {
        didSet {
            //register notification
            let center = NotificationCenter.default
            let notification = Notification(name: Notification.Name(rawValue: "localRooms"), object: self, userInfo: ["localRooms": localRooms!])
            center.post(notification)
        }
    }

    var viewControllerArray: [UIViewController] = [] {
        didSet {
            //register notification
            let center = NotificationCenter.default
            let notification = Notification(name: Notification.Name(rawValue: "vcArray"), object: self, userInfo: ["VCArray": viewControllerArray])
            center.post(notification)
        }
    }

    var pairedAccessories: [AccessoryItem] = [] {
        didSet {
            if !pairedAccessories.isEmpty {
                viewControllerArray = retrieveViewControllerList()
            }
        }
    }

    var beaconRoomConnectorArray: [BeaconRoomConnector] = []
    var newDict: NSDictionary?
    var newPlistArray: [NSDictionary] = []
    var majorBeacon: Int?
    var minorBeacon: Int?
    var isBeaconFound: Bool? = false

    var contextDelegate: ContextHandlerDelegate?
    var beaconController: BeaconController?

    override init() {
        super.init()

        if homeKitController == nil {
            homeKitController = HomeKitController()
        }
        homeKitController!.contextHandler = self

        accessoryStoryboard = UIStoryboard(name: "Accessories", bundle: nil)

        if beaconController == nil {
            beaconController = BeaconController()
        }
        beaconController!.delegate = self
        beaconController!.checkAuthorization()
    }

    // MARK: - Retrieve Homes

    func retrieveHome() -> String {
        return searchHome(forID: homeID!)
    }

    func searchHome(forID id: UUID) -> String {

        if let localHomes = localHomes {
            let homeName = localHomes.filter { $0.id == id }.first!.name
            return homeName!
        }

        return "No home found"
    }

    // MARK: - Retrieve rooms

    func retrieveRoom() -> String? {
        return searchRoom(forID: roomID) ?? "No room found"
    }

    func searchRoom(forID id: UUID?) -> String? {

        if let localRooms = localRooms {
            let roomName = localRooms.filter { $0.id == id }.first!.name
            return roomName!
        }

        return nil
    }

    // MARK: - Retrieve paired accessories for room

    func retrieveAccessories(_ completionHandler: @escaping () -> Void) {
        searchAccessoriesForRoom(homeID, roomID: roomID, completionHandler: completionHandler)
    }

    func searchAccessoriesForRoom(_ homeID: UUID?, roomID: UUID?, completionHandler: @escaping () -> Void) {
        if (homeID != nil) && (roomID != nil) {
            homeKitController!.retrieveAccessoriesForRoom(inHome: homeID!, roomID: roomID!, completionHandler: completionHandler)
        }
    }

    func retrieveViewControllerList() -> [UIViewController] {
        var localViewControllerArray: [UIViewController] = []

        for accessory in pairedAccessories {
            let controller = assignAccessoryToViewController(accessory)
            if let controller = controller {
                localViewControllerArray.append(controller)
            }
        }

        return localViewControllerArray
    }

    func assignAccessoryToViewController (_ accessory: AccessoryItem) -> UIViewController? {
        switch accessory {
        case is Lamp:
            let controller = accessoryStoryboard?.instantiateViewController(withIdentifier: "LightViewController") as! LightViewController
            controller.accessory = accessory
            controller.contextHandler = self
            return controller
        case is WeatherStation:
            let controller = accessoryStoryboard?.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            controller.accessory = accessory
            controller.contextHandler = self
            return controller
        case is EnergyController:
            let controller = accessoryStoryboard?.instantiateViewController(withIdentifier: "EnergyViewController") as! EnergyViewController
            controller.accessory = accessory
            controller.contextHandler = self
            return controller
        case is DoorWindowSensor:
            let controller = accessoryStoryboard?.instantiateViewController(withIdentifier: "DoorWindowViewController") as! DoorWindowViewController
            controller.accessory = accessory
            controller.contextHandler = self
            return controller
        case is Diverse, is Information:
            let controller = accessoryStoryboard?.instantiateViewController(withIdentifier: "DiverseViewController") as! DiverseViewController
            controller.accessory = accessory
            controller.contextHandler = self
            return controller
        default:
            return nil
        }
    }

    // TODO: fertig mit Characteristic darstellen
//    func accessoryCharacteristicLoaded(accessory: AccessoryItem) {
//        var countAccessories = 0
//        countAccessories++
//        
//        if viewControllerArray?.count == countAccessories {
//            
//        }
//    }

    // MARK: - Adding a new accessory

    func addNewAccessory(_ accessory: String, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void ) {
        homeKitController!.addAccessory(accessory, activeHomeID: homeID!, activeRoomID: roomID!, completionHandler: completionHandler)
    }

    // MARK: - Beacon functions

    func beaconFound(_ manager: BeaconController, major: Int, minor: Int) {
        isBeaconFound = true

        majorBeacon = major
        minorBeacon = minor

        contextDelegate?.roomForBeacon(self, connectorArray: beaconRoomConnectorArray, major: major, minor: minor)
    }

    // MARK: - Read and write beacon&room plist

    func loadSavedData() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("HomeKitData.plist")

        let fileManager = FileManager.default

        // Check if file exists
        if !fileManager.fileExists(atPath: path) {
            // If it doesn't, copy it from the default file in the Resources folder
            if let bundlePath = Bundle.main.path(forResource: "HomeKitData", ofType: "plist") {
//                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
//                print("Bundle HomeKitData.plist file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                } catch _ {
                }
                print("copy")
            }
        }

        beaconRoomConnectorArray.removeAll(keepingCapacity: false)

        if let content = NSArray(contentsOfFile: path) {
            newPlistArray = content as! [NSDictionary]
        }

        if !newPlistArray.isEmpty {
            let objects = newPlistArray.map { BeaconRoomConnector(dict: $0) }
            beaconRoomConnectorArray = objects
        } else {
            //TODO: 
            //keine Beacons verbunden
            print("No Beacons connected")
        }
    }

    func isBeaconConnected(_ home: String, room: String) -> (major: Int?, minor: Int?) {
        loadSavedData()
        let beacon = beaconRoomConnectorArray.filter { $0.room == room && $0.home == home }.first
        return (beacon?.major, beacon?.minor)
    }

    func saveData(_ object: BeaconRoomConnector) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("HomeKitData.plist")

        newDict = object.dictionaryForEntity()

        if let dict = newDict {

            let beaconConnected = beaconRoomConnectorArray.filter { $0.major == object.major && $0.minor == object.minor }
            let roomConnected = beaconRoomConnectorArray.filter { $0.home == object.home && $0.room == object.room }

            if !beaconConnected.isEmpty && !roomConnected.isEmpty {
                //Beacon ist mit diesem Raum schon verknüpft, nichts weiter tun
                print("Beacon ist mit diesem Raum schon verknüpft, nichts weiter tun")
            } else if roomConnected.isEmpty {
                //Beacon wurde schon in einem anderen Raum verwendet
                //"Sie haben dieses Beacon schon mit einem anderen Raum verknüpft. Möchten Sie dieses Beacon für diesen Raum verwenden?"
                print("Sie haben dieses Beacon schon mit einem anderen Raum verknüpft. Möchten Sie dieses Beacon für diesen Raum verwenden?")
            } else if beaconConnected.isEmpty {
                //Raum wurde schon mit einem anderen Beacon verknüpft
                //"Sie haben diesen Raum schon mit einem anderen Beacon verknüpft. Möchten Sie dieses Beacon für diesen Raum verwenden?"
                print("Sie haben diesen Raum schon mit einem anderen Beacon verknüpft. Möchten Sie dieses Beacon für diesen Raum verwenden?")
            } else {
                //Raum und Beacon sind noch nicht verknüpft
                //"Möchten Sie dieses Beacon für diesen Raum verwenden?"
                print("Möchten Sie dieses Beacon für diesen Raum verwenden?")
//                newPlistArray.append(dict)
            }

            if !newPlistArray.contains(dict) {
                newPlistArray.append(dict)
            } else {
                let index = newPlistArray.index(of: dict)
                newPlistArray[index!] = dict
            }

            beaconRoomConnectorArray.append(object)
        }

        print(beaconRoomConnectorArray)
        print(newPlistArray)
        (newPlistArray as NSArray).write(toFile: path, atomically: true)
    }

}
