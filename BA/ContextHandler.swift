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
    
    var localHomes : [Home]?
    var localRooms : [Room]?
    
    var delegate : ContextHandlerDelegate?
    
    var viewControllerArray : [UIViewController]?
    
    var pairedAccessories : [IAccessory]? {
        didSet {
            if let pairedAccessories = pairedAccessories, let oldValue = oldValue {
                if pairedAccessories.count != 0 {
                    if oldValue.count != pairedAccessories.count {
                        
                        //if oldValue does not contain the last paired accessory, it's a new accessory
                        let newAccessories = oldValue.filter { $0.name == pairedAccessories.last!.name }
                        if newAccessories.isEmpty {
                            delegate?.contextHandlerChangedVCArray()
                        }
                        
                    }
                }
            }
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
    
    
    // MARK: - Retrieve Rooms

    func retrieveRoom() -> String? {
        return searchRoom(forID: homeID)
    }
    
    func searchRoom(forID id: NSUUID?) -> String? {
        if let localRooms = localRooms {
            for rooms in localRooms {
                if rooms.homeID == id {
                    return rooms.name
                }
            }
        }
        return nil
    }
    
    
    // MARK: - Retrieve paired accessories
    
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
        homeKitController!.retrieveAccessoriesForRoom(inHome: homeID!, roomID: roomID!) { (accessories) -> () in
            foundAccessoriesForRoom = accessories
        }
        return foundAccessoriesForRoom!
    }
    
    func retrieveViewControllerList() -> [UIViewController]? {
        viewControllerArray = []
        
        pairedAccessories = retrieveAccessories()
        
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