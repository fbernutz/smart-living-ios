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
    
    func retrieveHome() -> String? {
        return searchHome(forID: homeID)
    }
    
    func retrieveRoom() -> String? {
        return searchRoom(forID: homeID)
    }
    
    
    
    //    func retrieveAccessories() {
    //        //gib alle Accessories für das Home>Room aus
    //        //homeID: NSUUID?, roomID: NSUUID?
    //
    //    }
    
}