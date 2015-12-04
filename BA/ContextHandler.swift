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
    
    var pairedAccessory : [IAccessory]?
    
    override init() {
        super.init()
        
        if homeKitController == nil {
            homeKitController = HomeKitController()
        }
        homeKitController!.contextHandler = self
        
    }
    
    
    func loadAccessoryBrowser(){
        homeKitController!.startSearchingForAccessories()
//        searchNewAccessories()
    }
    
    func addAccessory(accessory: String) {
        homeKitController?.addAccessory(accessory, activeHomeID: homeID!, activeRoomID: roomID!)
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
//    
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
    
    
    // MARK: - Retrieve Accessories
    
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
        homeKitController?.retrieveAccessoriesForRoom(inHome: homeID!, roomID: roomID!) { (accessories) -> () in
            foundAccessoriesForRoom = accessories
        }
        return foundAccessoriesForRoom!
    }
    
    func searchNewAccessories() -> [IAccessory] {
        var foundAccessoriesForRoom : [IAccessory]?
        homeKitController?.retrieveNewAccessories() { (accessories) -> () in
            foundAccessoriesForRoom = accessories
        }
        
        if let foundAccessoriesForRoom = foundAccessoriesForRoom {
            return foundAccessoriesForRoom
        } else {
            return []
        }
    }
    
    
}