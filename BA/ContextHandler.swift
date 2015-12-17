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
    
    var homeID : NSUUID?
    var roomID : NSUUID?
    
    var homeKitController : HomeKitController?
    var localHomes : [Home]?
    var localRooms : [Room]?
    
    var characteristicProperties : CharacteristicProperties?
    var viewControllerArray : [UIViewController]?
    
    var accessoryStoryboard : UIStoryboard?
    
    var pairedAccessories : [IAccessory]? {
        didSet {
            if oldValue != nil {
                for accessory in oldValue! {
                    if pairedAccessories?.last?.name != accessory.name {
                        assignAccessoryToViewController(pairedAccessories!.last!)
                    }
                }
            }
        }
    }
    var lightController : LightViewController?
    var diverseController : DiverseViewController?
    
    
    override init() {
        super.init()
        
        if homeKitController == nil {
            homeKitController = HomeKitController()
        }
        homeKitController!.contextHandler = self
        
        characteristicProperties = CharacteristicProperties()
        accessoryStoryboard = UIStoryboard(name: "Accessories", bundle: nil)
    }
    
    func loadAccessoryBrowser(){
        homeKitController!.startSearchingForAccessories()
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
        case is Diverse:
            let controller = accessoryStoryboard?.instantiateViewControllerWithIdentifier("DiverseViewController") as? DiverseViewController
            controller!.accessory = accessory
            viewControllerArray?.append(controller!)
            break
        default:
            break
        }
    }
    
    func retrieveViewControllerList() -> [UIViewController]? {
        viewControllerArray = []
        
        for accessory in pairedAccessories! {
            assignAccessoryToViewController(accessory)
        }
        
        return viewControllerArray
    }
    
    // MARK: - Retrieve Homes
    
    //    Bei der Anfrage gibst Du einen Block / Closure nach unten
    //    die speicherst Du in einer Variable und startest die Anfrage an Homekit.
    //    Wenn HomeKit den Delegate aufruft, schaust Du ob die Block/Closure-Variable gesetzt ist und wenn ja, führst Du sie aus.
    
//    func retrieveHomes() -> [Home]? {
//        if !searchHomes().isEmpty {
//            let foundHomes = searchHomes()
//            return foundHomes
//        } else {
//            return nil
//        }
//    }
    
//    func searchHomes() -> [Home] {
//        var foundHomes : [Home]?
//        homeKitController?.retrieveHomes2(completionHandler: { (homes) -> () in
//                foundHomes = homes
//        })
//        
//        if let foundHomes = foundHomes {
//            return foundHomes
//        } else {
//            return []
//        }
//    }
    
    
    func retrieveHome() -> String? {
        return searchHome(forID: homeID)
    }
    
    func searchHome(forID id: NSUUID?) -> String? {
        if let localHomes = localHomes {
            for homes in localHomes {
                if homes.id == id {
                    return homes.name
                }
            }
        }
        
        return nil
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
        if !searchAccessoriesForRoom(homeID, roomID: roomID).isEmpty {
            let accessoriesInRoom = searchAccessoriesForRoom(homeID, roomID: roomID)
            return accessoriesInRoom
        } else {
            return nil
        }
    }
    
    func searchAccessoriesForRoom(homeID: NSUUID?, roomID: NSUUID?) -> [IAccessory] {
        var foundAccessoriesForRoom : [IAccessory]?
        homeKitController!.retrieveAccessoriesForRoom(inHome: homeID!, roomID: roomID!) { (accessories) -> () in
            foundAccessoriesForRoom = accessories
        }
        return foundAccessoriesForRoom!
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