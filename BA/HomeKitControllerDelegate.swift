//
//  HomeKitControllerDelegate.swift
//  BA
//
//  Created by Felizia Bernutz on 30.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import Foundation

protocol HomeKitControllerDelegate {
    
    func hasLoadedData(status: Bool)
    func hasLoadedNewAccessoriesList(accessoryNames: [String])
//    func hasLoadedHomes(homes: [Home])
//    func hasLoadedRooms(rooms: [Room])
//    func hasLoadedAccessories(accessory: [IAccessory])
    
}
