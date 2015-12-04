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
//    var localAccessories : [IAccessory]?
    var homeKitController : HomeKitController?
    
    //    enum ServiceTypes {
    //        case LightService
    //        case EveDoorWindowService
    //        case EveWeatherService
    //        case EveEnergyService
    //    }
    
    
    override init() {
        super.init()
    }
    
    
    // MARK: - Service To Local
    
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
    
//    func serviceToLocalAccessories(homeKitAccessories: [HMAccessory]) -> [IAccessory]? {
//        localAccessories = []
//        for accessory in homeKitAccessories {
////            localAccessories?.append()
//        }
//        return localAccessories
//    }
    
    
    // MARK: - Local To Service
    
    func localHomeToService(localHome: Home) {
        homeKitController?.addHome(localHome.name!)
    }
    
    func localRoomToService(localRoom: Room) {
        for home in (homeKitController?.homeManager.homes)! {
            if home.uniqueIdentifier == localRoom.homeID {
                homeKitController?.addRoom(localRoom.name!, toHome: home)
            }
        }
    }
    
    
}