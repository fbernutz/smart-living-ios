//
//  HomeViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 09.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit
import HomeKit

class HomeKitController: NSObject, HMHomeManagerDelegate, HMAccessoryBrowserDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var contextHandler : ContextHandler?
    var delegate: HomeKitControllerDelegate?
    var accessoryDelegate : HomeKitControllerNewAccessoriesDelegate?
    
    var homeManager = HMHomeManager()
    var accessoryBrowser = HMAccessoryBrowser()
    lazy var homeHelper = HomeHelper()
    lazy var accessoryFactory = AccessoryFactory()
    var services = [HMService]()
    
    var primaryHome: HMHome?
    
    var currentHomeID : NSUUID?
    var currentRoomID : NSUUID?
    
    var homes = [HMHome]() {
        didSet {
            
        }
    }
    
    var rooms = [HMRoom]() {
        didSet {
            
            // TODO: wenn ein Service Room neu erstellt wird, Umwandlung in lokale Struktur nochmal überarbeiten - noch falsch
            // homeHelper?.serviceToLocalRooms(homes)
        }
    }
    
    var pairedAccessories : [IAccessory]? = [] {
        didSet {
            print(pairedAccessories)
            contextHandler?.pairedAccessories = pairedAccessories
        }
    }
    
    var unpairedAccessories = [HMAccessory]() {
        didSet {
            let newAccessoryArray = unpairedAccessories.map({ $0.name }).last
            accessoryDelegate?.hasLoadedNewAccessoriesList([newAccessoryArray!], stillLoading: true)
        }
    }
    
    var accessoryBlock : (() -> ())?
    var newAccessoryBlock : (() -> ())?
    var homesBlock : (() -> ())?
    
    
    // MARK: - Setup
    
    override init() {
        super.init()
        
        homeManager.delegate = self
        accessoryBrowser.delegate = self
        homeHelper.homeKitController = self
    }
    
    // MARK: - Start and stop searching for new accessories
    
    func startSearchingForAccessories() {
        accessoryBrowser.startSearchingForNewAccessories()
        NSTimer.scheduledTimerWithTimeInterval(7.0, target: self, selector: "stopSearching", userInfo: nil, repeats: false)
        
        if !unpairedAccessories.isEmpty {
            let newAccessoryArray = unpairedAccessories.map({ $0.name })
            accessoryDelegate?.hasLoadedNewAccessoriesList(newAccessoryArray, stillLoading: true)
        }
    }
    
    func stopSearching() {
        accessoryBrowser.stopSearchingForNewAccessories()
        
        if !unpairedAccessories.isEmpty {
            let newAccessoryArray = unpairedAccessories.map({ $0.name })
            accessoryDelegate?.hasLoadedNewAccessoriesList(newAccessoryArray, stillLoading: false)
        }
        
        if let block = newAccessoryBlock {
            block()
            newAccessoryBlock = nil
        }
    }
    
    // MARK: - Retrieve Methods
    
    func retrieveAccessoriesForRoom(inHome homeID: NSUUID, roomID: NSUUID, completionHandler : ([IAccessory]) -> ()) {
        if !homes.isEmpty {
            getIAccessories(roomID, inHome: homeID, completionHandler: completionHandler)
        } else {
            accessoryBlock = { () in self.getIAccessories(roomID, inHome: homeID, completionHandler: completionHandler)}
        }
    }
    
    private func getIAccessories(roomID: NSUUID, inHome homeID: NSUUID, completionHandler : ([IAccessory]) -> ()) {
        let accessories = homes.filter({ $0.uniqueIdentifier == homeID }).first?.rooms.filter({ $0.uniqueIdentifier == roomID }).first?.accessories
        
        if accessories != nil {
            pairedAccessories = accessories!.map({
                let service = $0.services.last!
                
                var new = accessoryFactory.accessoryForServices(service)!
                new.name = $0.name
                new.uniqueID = $0.uniqueIdentifier
                accessoryFactory.characteristicForService(new, service: service, completionHandler: { characteristicProperties in
                    new.characteristicProperties = characteristicProperties
                })
                
                return new
            })
            completionHandler(pairedAccessories!)
        }
        
    }
    
    //ACCESSORY LIST
    
    func retrieveNewAccessories(completionHandler : ([IAccessory]) -> ()) {
        if !unpairedAccessories.isEmpty {
            getNewIAccessories(completionHandler)
        } else {
            newAccessoryBlock = { () in self.getNewIAccessories(completionHandler) }
        }
    }
    
    func getNewIAccessories(completionHandler : ([IAccessory]) -> ()) {
        let arrayOfIAccessories = unpairedAccessories.map({ accessoryFactory.accessoryForServices($0.services[1])! })
        completionHandler(arrayOfIAccessories)
    }
    
    //    func accessoriesForRoomWithID() -> Accessory? {
    //        //mitgeben welchen Service man braucht -> Licht oder GarageDoorOpener
    //
    //        return nil
    //    }
    
        // MARK: - Home Delegate
    
    //homeManager finished loading the home data
    func homeManagerDidUpdateHomes(manager: HMHomeManager) {
        // Set homes
        homes = manager.homes
        
        // Set rooms
        for home in homes {
            rooms += home.rooms
        }
        
        // If one of them is still empty, create one default home and room
        if homes.isEmpty || rooms.isEmpty {
            initialHomeSetup("Default Home",roomName: "Default Room")
        } else {
            homesAreSet()
            roomsAreSet()
        }
        
        if let home = manager.primaryHome {
            primaryHome = home
        }
        
        if let block = accessoryBlock {
            block()
            accessoryBlock = nil
        }
        
        if let block = homesBlock {
            block()
            homesBlock = nil
        }
    }
    
    func homesAreSet() {
        if !homes.isEmpty {
            retrieveHomes(completionHandler: { (homes) -> () in
                self.contextHandler!.localHomes = homes
            })
        } else {
            print ("Failed: Homes are not set yet or set to nil")
        }
    }
    
    func roomsAreSet() {
        if !rooms.isEmpty {
            retrieveRooms(homes, completionHandler: { (rooms) -> () in
                self.contextHandler!.localRooms = rooms
            })
            
            retrieveCurrentHomeAndRoom { (homeID, roomID) -> () in
                self.contextHandler!.homeID = homeID
                self.contextHandler!.roomID = roomID
            }
            
            delegate?.hasLoadedData(true)
            
        } else {
            print ("Failed: Rooms are not set yet or set to nil")
        }
    }
    
    func retrieveHomes(completionHandler completion: (homes: [Home]) -> ()) {
        let localHome = homeHelper.serviceToLocalHomes(homes)
        completion(homes: localHome!)
    }
    
    func retrieveRooms(homes: [HMHome], completionHandler completion: (rooms: [Room]) -> ()) {
        let localRooms = homeHelper.serviceToLocalRooms(homes)
        completion(rooms: localRooms!)
    }
    
    func retrieveCurrentHomeAndRoom(completionHandler completion: (homeID: NSUUID, roomID: NSUUID) -> ()){
        var index = 0
        for home in homes {
            if !home.rooms.isEmpty {
                currentHomeID = homes[index].uniqueIdentifier
                currentRoomID = homes[index].rooms[0].uniqueIdentifier
                break
            }
            index++
        }
        
        completion(homeID: currentHomeID!, roomID: currentRoomID!)
    }
    
    func homeManager(manager: HMHomeManager, didAddHome home: HMHome) {
        homes.append(home)
        homesAreSet()
    }
    
    func homeManager(manager: HMHomeManager, didAddRoom room: HMRoom) {
        rooms.append(room)
        roomsAreSet()
    }
    
    func homeManagerDidUpdatePrimaryHome(manager: HMHomeManager) {
        print("Did update home")
    }
    
    func homeManager(manager: HMHomeManager, didRemoveHome home: HMHome) {
        var index = 0
        for elem in homes {
            if elem == home {
                homes.removeAtIndex(index)
            }
            index++
        }
    }
    
    // MARK: - Accessory Delegate
    
    func accessoryBrowser(browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        unpairedAccessories.append(accessory)
    }
    
    func accessoryBrowser(browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        let _ = unpairedAccessories.map({
            if $0.name == accessory.name {
                unpairedAccessories.removeAtIndex(unpairedAccessories.indexOf($0)!)
            }
        })
    }
    
    // MARK: - HomeKit Methods
    
    //Create first Home as Primary Home and first Room
    func initialHomeSetup (homeName: String, roomName: String) {
        
        switch homes.count {
        case 0:
            homeManager.addHomeWithName(homeName) { home, error in
                if let error = error {
                    print("Something went wrong when attempting to create our home. \(error.localizedDescription)")
                } else {
                    // TODO
                    home!.addRoomWithName(roomName) { room, error in
                        if let error = error {
                            print("Something went wrong when attempting to create our home. \(error.localizedDescription)")
                        } else {
                            self.homes.append(home!)
                            self.rooms.append(room!)
                            self.homesAreSet()
                            self.roomsAreSet()
                        }
                    }
                    self.updatePrimaryHome(home!)
                }
            }
        default:
            for home in homes {
                if home.name == homeName {
                    if home.rooms.isEmpty {
                        home.addRoomWithName(roomName) { room, error in
                            if let error = error {
                                print("Something went wrong when attempting to create our home. \(error.localizedDescription)")
                            } else {
                                self.rooms.append(room!)
                                self.homesAreSet()
                                self.roomsAreSet()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func addHome (withName: String) {
        homeManager.addHomeWithName(withName) { home, error in
            if let error = error {
                print("Something went wrong when attempting to create our home. \(error.localizedDescription)")
            } else {
                //
            }
        }
    }
    
    func addRoom (withName: String, toHome: HMHome) {
        toHome.addRoomWithName(withName) { room, error in
            if let error = error {
                print("Something went wrong when attempting to create our room. \(error.localizedDescription)")
            } else {
                // TODO
                self.rooms.append(room!)
            }
        }
    }
    
    func updatePrimaryHome (home: HMHome) {
        homeManager.updatePrimaryHome(home) { error in
            if let error = error {
                print("Something went wrong when attempting to make this home our primary home. \(error.localizedDescription)")
            } else {
                // TODO
                self.primaryHome = home
            }
        }
    }
    
    func removeHome (home: HMHome) {
        homeManager.removeHome(home) { error in
            if let error = error {
                print ("Error: \(error)")
            } else {
                // TODO
            }
        }
    }
    
    func addAccessory (accessory: String, activeHomeID: NSUUID, activeRoomID: NSUUID, completionHandler: () -> () ) {
        
        let homeKitAccessory = unpairedAccessories.filter{$0.name == accessory}.first!
        let activeHome = homes.filter{$0.uniqueIdentifier == activeHomeID}.first!
        let activeRoom = homes.filter{$0.uniqueIdentifier == activeHomeID}.first!.rooms.filter{$0.uniqueIdentifier == activeRoomID}.first!
        
        activeHome.addAccessory(homeKitAccessory, completionHandler: { (error) -> Void in
            if error != nil {
                print("Something went wrong when attempting to add an accessory to \(activeHome.name). \(error!.localizedDescription)")
            } else {
                activeHome.assignAccessory(homeKitAccessory, toRoom: activeRoom, completionHandler: { (error) -> Void in
                    if error != nil {
                        print("Something went wrong when attempting to add an accessory to \(activeRoom.name). \(error!.localizedDescription)")
                    } else {
                        let newAccessory = self.accessoryFactory.accessoryForServices(homeKitAccessory.services.last!)
                        self.pairedAccessories?.append(newAccessory!)
                        completionHandler()
                    }
                })
                
            }
        })
    }
    

}