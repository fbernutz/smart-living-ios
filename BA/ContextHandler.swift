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
    
    var homeID : NSUUID?
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
            viewControllerArray = retrieveViewControllerList()
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
    
    // MARK: - Add new accessory
    
    func addNewAccessory(accessory: String, completionHandler: (success: Bool, error: NSError?) -> () ) {
        homeKitController!.addAccessory(accessory, activeHomeID: homeID!, activeRoomID: roomID!, completionHandler: completionHandler)
    }
    
}