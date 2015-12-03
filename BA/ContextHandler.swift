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
    
    override init() {
        super.init()
        
        if homeKitController == nil {
            homeKitController = HomeKitController()
        }
    }
    
    
    // MARK: - Retrieve Homes

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
    
    func retrieveAccessories() -> IAccessory? {
        if !searchAccessories(homeID, roomID: roomID).isEmpty {
            let acc = searchAccessories(homeID, roomID: roomID).first
            return acc
        } else {
            return nil
        }
    }
    
    func searchAccessories(homeID: NSUUID?, roomID: NSUUID?) -> [IAccessory] {
        
        // TODO: Gib alle Accessories für Home > Room aus
        var foundAccessoriesForRoom : [IAccessory]?
        homeKitController?.retrieveAccessoriesForRoom(inHome: homeID!, roomID: roomID!, completionHandler: { (accessories) -> () in
            foundAccessoriesForRoom = accessories
        })
        return foundAccessoriesForRoom!
    }
    
    
}