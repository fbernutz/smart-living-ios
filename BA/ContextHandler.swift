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
    
    var accessoryStoryboard : UIStoryboard?
    var homeKitController : HomeKitController?
    
    var homeID : NSUUID?
    
    var roomID : NSUUID? {
        didSet {
            //register notification
            let center = NSNotificationCenter.defaultCenter()
            let notification = NSNotification(name: "roomID", object: self, userInfo: ["roomID":roomID!])
            center.postNotification(notification)
        }
    }
    
    var localHomes : [Home]? {
        didSet {
            //register notification
            let center = NSNotificationCenter.defaultCenter()
            let notification = NSNotification(name: "localHomes", object: self, userInfo: ["localHomes":localHomes!])
            center.postNotification(notification)
        }
    }
    
    var localRooms : [Room]? {
        didSet {
            //register notification
            let center = NSNotificationCenter.defaultCenter()
            let notification = NSNotification(name: "localRooms", object: self, userInfo: ["localRooms":localRooms!])
            center.postNotification(notification)
        }
    }
    
    var viewControllerArray : [UIViewController]? = [] {
        didSet {
            if viewControllerArray?.count == pairedAccessories?.count {
                //register notification
                let center = NSNotificationCenter.defaultCenter()
                let notification = NSNotification(name: "vcArray", object: self, userInfo: ["VCArray":viewControllerArray!])
                center.postNotification(notification)
            }
        }
    }
    
    var pairedAccessories : [IAccessory]? {
        didSet {
            viewControllerArray = retrieveViewControllerList()
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
    
    func searchHome(forID id: NSUUID) -> String {
        
        if let localHomes = localHomes {
            let homeName = localHomes.filter{ $0.id == id }.first!.name
            return homeName!
        }
        
        return "No home found"
    }
    
    
    // MARK: - Retrieve rooms
    
    func retrieveRoom() -> String? {
        return searchRoom(forID: roomID) ?? "No room found"
    }
    
    func searchRoom(forID id: NSUUID?) -> String? {
        
        if let localRooms = localRooms {
            let roomName = localRooms.filter{ $0.id == id }.first!.name
            return roomName!
        }
        
        return nil
    }
    
    
    // MARK: - Retrieve paired accessories for room
    
    func retrieveAccessories() -> [IAccessory]? {
        let accessoriesInRoom = searchAccessoriesForRoom(homeID, roomID: roomID)
        
        if !accessoriesInRoom.isEmpty {
            return accessoriesInRoom
        } else {
            return nil
        }
    }
    
    func searchAccessoriesForRoom(homeID: NSUUID?, roomID: NSUUID?) -> [IAccessory] {
        var foundAccessoriesForRoom : [IAccessory]? = []
        if (homeID != nil) && (roomID != nil) {
            homeKitController!.retrieveAccessoriesForRoom(inHome: homeID!, roomID: roomID!) { (accessories) -> () in
                foundAccessoriesForRoom = accessories
            }
        } else {
            pairedAccessories = []
        }
        return foundAccessoriesForRoom!
    }
    
    func retrieveViewControllerList() -> [UIViewController]? {
        viewControllerArray?.removeAll()
        
        if let pairedAccessories = pairedAccessories {
            for accessory in pairedAccessories {
                assignAccessoryToViewController(accessory)
            }
        }
        
        return viewControllerArray
    }
    
    func assignAccessoryToViewController (accessory: IAccessory) {
        switch accessory {
        case is Lamp:
            let controller = accessoryStoryboard?.instantiateViewControllerWithIdentifier("LightViewController") as? LightViewController
            controller!.accessory = accessory
            controller!.contextHandler = self
            viewControllerArray?.append(controller!)
            break
        case is WeatherStation:
            let controller = accessoryStoryboard?.instantiateViewControllerWithIdentifier("WeatherViewController") as? WeatherViewController
            controller!.accessory = accessory
            viewControllerArray?.append(controller!)
            break
        case is EnergyController:
            let controller = accessoryStoryboard?.instantiateViewControllerWithIdentifier("EnergyViewController") as? EnergyViewController
            controller!.accessory = accessory
            controller!.contextHandler = self
            viewControllerArray?.append(controller!)
            break
        case is DoorWindowSensor:
            let controller = accessoryStoryboard?.instantiateViewControllerWithIdentifier("DoorWindowViewController") as? DoorWindowViewController
            controller!.accessory = accessory
            viewControllerArray?.append(controller!)
            break
        case is Diverse, is Information:
            let controller = accessoryStoryboard?.instantiateViewControllerWithIdentifier("DiverseViewController") as? DiverseViewController
            controller!.accessory = accessory
            viewControllerArray?.append(controller!)
            break
        default:
            break
        }
    }
    
    // TODO: fertig mit Characteristic darstellen
//    func accessoryCharacteristicLoaded(accessory: IAccessory) {
//        var countAccessories = 0
//        countAccessories++
//        
//        if viewControllerArray?.count == countAccessories {
//            
//        }
//    }
    
    
    // MARK: - Adding a new accessory
    
    func addNewAccessory(accessory: String, completionHandler: (success: Bool, error: NSError?) -> () ) {
        homeKitController!.addAccessory(accessory, activeHomeID: homeID!, activeRoomID: roomID!, completionHandler: completionHandler)
    }
    
    // MARK: - Beacon functions
    
    func beaconFound(manager: BeaconController, major: Int, minor: Int){
        isBeaconFound = true
        
        majorBeacon = major
        minorBeacon = minor
        
//        loadSavedData()
        // TODO: hier zurückgeben lassen ob für das gefunden Beacon schon ein Raum gesetzt wurde und evtl. von selbst anbieten das Beacon zu setzen
        // und vorher überprüfen ob für den Raum schon ein Beacon gesetzt wurde
        
        contextDelegate?.roomForBeacon(self, connectorArray: beaconRoomConnectorArray, major: major, minor: minor)
    }
    
    // MARK: - Read and write beacon&room plist
    
    func loadSavedData() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("HomeKitData.plist")
        
        let fileManager = NSFileManager.defaultManager()
        
        // Check if file exists
        if !fileManager.fileExistsAtPath(path)
        {
            // If it doesn't, copy it from the default file in the Resources folder
            if let bundlePath = NSBundle.mainBundle().pathForResource("HomeKitData", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle HomeKitData.plist file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                } catch _ {
                }
                print("copy")
            }
        }
        
        beaconRoomConnectorArray.removeAll(keepCapacity: false)
        
        if let content = NSArray(contentsOfFile: path) {
            newPlistArray = content as! [NSDictionary]
        }
        
        if !newPlistArray.isEmpty {
            let objects = newPlistArray.map{ BeaconRoomConnector(dict: $0) }
            beaconRoomConnectorArray = objects
        } else {
            //TODO: 
            //keine Beacons verbunden
            print("No Beacons connected")
        }
    }
    
    func isBeaconConnected(home: String, room: String) -> (major: Int?, minor: Int?) {
        loadSavedData()
        let beacon = beaconRoomConnectorArray.filter{ $0.room == room && $0.home == home }.first
        return (beacon?.major, beacon?.minor)
    }
    
    func saveData(object: BeaconRoomConnector) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("HomeKitData.plist")
        
        newDict = object.dictionaryForEntity()
        
        if let dict = newDict {
            
            let beaconConnected = beaconRoomConnectorArray.filter{ $0.major == object.major && $0.minor == object.minor }
            let roomConnected = beaconRoomConnectorArray.filter{ $0.home == object.home && $0.room == object.room }
            
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
                let index = newPlistArray.indexOf(dict)
                newPlistArray[index!] = dict
            }
            
            beaconRoomConnectorArray.append(object)
        }
        
        print(beaconRoomConnectorArray)
        print(newPlistArray)
        (newPlistArray as NSArray).writeToFile(path, atomically: true)
    }
    
}