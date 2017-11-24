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
    
    
    // MARK: - Service To Local
    
    func serviceToLocalHomes(_ homeKitHomes: [HMHome]) -> [Home]? {
        localHomes = []
        for home in homeKitHomes {
            localHomes?.append(Home(id: home.uniqueIdentifier, name: home.name, primary: home.isPrimary))
        }
        return localHomes
    }
    
    func serviceToLocalRooms(_ homeKitHomes: [HMHome]) -> [Room]? {
        localRooms = []
        for home in homeKitHomes {
            for room in home.rooms {
                localRooms?.append(Room(homeID: home.uniqueIdentifier, id: room.uniqueIdentifier, name: room.name))
            }
        }
        return localRooms
    }
    
    
    // MARK: - Local To Service
    
    func localHomeToService(_ localHome: Home) {
        homeKitController?.addHome(localHome.name!)
    }
    
    func localRoomToService(_ localRoom: Room) {
        let _ = homeKitController?.homeManager.homes.filter{ $0.uniqueIdentifier == localRoom.homeID }.map{ homeKitController?.addRoom(localRoom.name!, toHome: $0) }
    }
    
    
}
