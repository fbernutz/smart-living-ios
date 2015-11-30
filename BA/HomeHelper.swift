//
//  HomeHelper.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import Foundation
import HomeKit

class HomeHelper: NSObject, HMHomeManagerDelegate {
    
    var localHomes : [Home]?
    var localRooms : [Room]?
    var homeKitController : HomeKitController?
    
    override init() {
        super.init()
    }
    
    // MARK: - Conversions from localHomes to homeKitHomes and vice versa
    
    func serviceToLocalHomes(homeKitHomes: [HMHome]) -> [Home]? {
        localHomes = []
        for home in homeKitHomes {
            localHomes?.append(Home(id: home.uniqueIdentifier, name: home.name, primary: home.primary))
        }
        
        return localHomes
    }
    
    func serviceToLocalRooms(homeKitHomes: [HMHome]) -> [Room]? {
        localRooms = []
        for home in homeKitHomes {
            for room in home.rooms {
                localRooms?.append(Room(homeID: home.uniqueIdentifier, id: room.uniqueIdentifier, name: room.name))
            }
        }
        
        return localRooms
    }
    
    func localHomeToService(localHome: Home) {
        homeKitController?.addHome(localHome.name!)
    }
    
    func localRoomToService(localRoom: Room) {
        
        //search in homeManager for home with id from localRoom
        for home in (homeKitController?.homeManager?.homes)! {
            if home.uniqueIdentifier == localRoom.homeID {
                homeKitController?.addRoom(localRoom.name!, toHome: home)
            }
        }
    }
    
    
    
}