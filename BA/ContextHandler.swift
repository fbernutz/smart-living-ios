//
//  ContextHandler.swift
//  BA
//
//  Created by Felizia Bernutz on 18.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit
import HomeKit

class ContextHandler: NSObject, HMHomeManagerDelegate {
    
    var accessoryStoryboard : UIStoryboard?
    var homeKitController : HomeKitController?
    
    var homeID : NSUUID? {
        didSet {
            
        }
    }
    var roomID : NSUUID?
    
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
//            print(oldValue, pairedAccessories)
            
            viewControllerArray = retrieveViewControllerList()
            
            //1. first time
//            if oldValue == nil {
//                viewControllerArray = retrieveViewControllerList()
//                
//            }
//            
//            if let pairedAccessories = pairedAccessories, let oldValue = oldValue {
//                
//                //2. new characteristics for paired accessory
//                if (oldValue.count == pairedAccessories.count) && (!pairedAccessories.isEmpty) {
//                    for accessory in pairedAccessories {
//                        let changedAccessories = oldValue.filter { ($0.name == accessory.name) && ($0.characteristics.count != accessory.characteristics.count) }
//                        if !changedAccessories.isEmpty {
//                            viewControllerArray = retrieveViewControllerList()
//                            
//                        }
//                    }
//                }
//            
//                //3. added new accessory
//                if (!pairedAccessories.isEmpty) && (oldValue.count != pairedAccessories.count) {
//                    //if oldValue does not contain the last paired accessory, it's a new accessory
//                    let newAccessories = oldValue.filter { $0.name == pairedAccessories.last!.name }
//                    if newAccessories.isEmpty {
//                        viewControllerArray = retrieveViewControllerList()
//                    }
//                    
//                }
//            }
        }
    }
    
    
    override init() {
        super.init()
        
        if homeKitController == nil {
            homeKitController = HomeKitController()
        }
        homeKitController!.contextHandler = self
        
        accessoryStoryboard = UIStoryboard(name: "Accessories", bundle: nil)
    }
    
    
    // MARK: - Retrieve Homes
    
    func retrieveHome() -> String {
        return searchHome(forID: homeID!)
    }
    
    func searchHome(forID id: NSUUID) -> String {
        if let localHomes = localHomes {
            for homes in localHomes {
                if homes.id == id {
                    return homes.name!
                }
            }
        }
        
        return ""
    }
    
    
    // MARK: - Retrieve rooms

    func retrieveRoom() -> String? {
        return searchRoom(forID: roomID) ?? "No room found"
    }
    
    func searchRoom(forID id: NSUUID?) -> String? {
        if let localRooms = localRooms {
            for rooms in localRooms {
                if rooms.id == id {
                    return rooms.name
                }
            }
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
    
    // MARK: - Retrieve unpaired accessory list
    
    func searchNewAccessories() -> [IAccessory] {
        var foundAccessoriesForRoom : [IAccessory]?
        homeKitController!.retrieveNewAccessories() { (accessories) -> () in
            foundAccessoriesForRoom = accessories
        }
        
        if let foundAccessoriesForRoom = foundAccessoriesForRoom {
            return foundAccessoriesForRoom
        } else {
            return []
        }
    }
    
    // MARK: - Add new accessory
    
    func addAccessory(accessory: String, completionHandler: () -> () ) {
        homeKitController!.addAccessory(accessory, activeHomeID: homeID!, activeRoomID: roomID!, completionHandler: completionHandler)
    }
    
}