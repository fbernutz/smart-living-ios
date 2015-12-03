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
    var delegate: HomeKitControllerDelegate?

    var homeManager : HMHomeManager?
    var accessoryBrowser : HMAccessoryBrowser?
    var homeHelper : HomeHelper?
    lazy var accessoryFactory = AccessoryFactory()
    
    var primaryHome: HMHome?
    var accessories = [HMAccessory]()
    var services = [HMService]()
    
    var currentHomeID : NSUUID?
    var currentRoomID : NSUUID?
    
    var homes = [HMHome]() {
        didSet {
            appDelegate.contextHandler?.localHomes = homeHelper!.serviceToLocalHomes(homes)
            
//            delegate?.hasLoadedHomes(homeHelper!.serviceToLocalHomes(homes)!)
            
            appDelegate.contextHandler?.localRooms = homeHelper!.serviceToLocalRooms(homes)
        }
    }
    
    var rooms = [HMRoom]() {
        didSet {
            // TODO: wenn ein Service Room neu erstellt wird, Umwandlung in lokale Struktur nochmal überarbeiten - noch falsch
            // homeHelper?.serviceToLocalRooms(homes)
        }
    }
    
    
    // MARK: - Setup
    
    override init() {
        super.init()
        
        if homeManager == nil {
            homeManager = HMHomeManager()
        }
        homeManager!.delegate = self
        
        if accessoryBrowser == nil {
            accessoryBrowser = HMAccessoryBrowser()
        }
        accessoryBrowser!.delegate = self
//        accessoryBrowser!.startSearchingForNewAccessories()
        
//        NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "stopSearching", userInfo: nil, repeats: false)
        
        
        if homeHelper == nil {
            homeHelper = HomeHelper()
        }
        homeHelper!.homeKitController = self
        
    }
    
//    func stopSearching() {
//        accessoryBrowser!.stopSearchingForNewAccessories()
//    }
    
    
    // MARK: - Retrieve Methods
    
    func retrieveHomeWithID() -> NSUUID? {
          return currentHomeID
    }

    func retrieveRoomWithID() -> NSUUID? {
        return currentRoomID
    }
    
    var accessoryBlock : (() -> ())?
    
    func retrieveAccessoriesForRoom(inHome homeID: NSUUID, roomID: NSUUID, completionHandler : ([IAccessory]) -> ()) {
        if !homes.isEmpty {
            getIAccessories(roomID, inHome: homeID, completionHandler: completionHandler)
        } else {
            //merken und ids, homes holen und dann func aufrufen
            accessoryBlock = { () in self.getIAccessories(roomID, inHome: homeID, completionHandler: completionHandler)}
            //let a = accessoryBlock!() // call this when HomeKit data returns from HomeKit
        }
    }
    
    private func getIAccessories (roomID: NSUUID, inHome homeID: NSUUID, completionHandler : ([IAccessory]) -> ()) {
        let accessories = homes.filter({ $0.uniqueIdentifier == homeID }).first?.rooms.filter({ $0.uniqueIdentifier == roomID }).first?.accessories
        let arrayOfIAccessories = accessories?.map({ accessoryFactory.accessoryForServices($0.services.first!)! })
        completionHandler(arrayOfIAccessories!)
    }

//    func accessoriesForRoomWithID() -> Accessory? {
//        //mitgeben welchen Service man braucht -> Licht oder GarageDoorOpener
//    
//        return nil
//    }
    
    //Create first Home as Primary Home and first Room
    func initialHomeSetup (homeName: String, roomName: String) {
        homeManager!.addHomeWithName(homeName) { home, error in
            if let error = error {
                print("Something went wrong when attempting to create our home. \(error.localizedDescription)")
            } else {
                // TODO
                self.addRoom(roomName, toHome: home!)
                self.updatePrimaryHome(home!)
            }
        }
    }
    
    func addHome (withName: String) {
        homeManager!.addHomeWithName(withName) { home, error in
            if let error = error {
                print("Something went wrong when attempting to create our home. \(error.localizedDescription)")
            } else {
                // TODO
                
            }
        }
    }
    
    func addRoom (withName: String, toHome: HMHome){
        toHome.addRoomWithName(withName) { room, error in
            if let error = error {
                print("Something went wrong when attempting to create our room. \(error.localizedDescription)")
            } else {
                // TODO
                self.rooms.append(room!)
                print(self.rooms)
            }
        }
    }
    
    func updatePrimaryHome (home: HMHome) {
        homeManager!.updatePrimaryHome(home) { error in
            if let error = error {
                print("Something went wrong when attempting to make this home our primary home. \(error.localizedDescription)")
            } else {
                // TODO
                self.primaryHome = home
            }
        }
    }
    
    func removeHome (home: HMHome) {
        homeManager!.removeHome(home) { error in
            if let error = error {
                print ("Error: \(error)")
            } else {
                // TODO
                
            }
        }
    }
    
    func addAccessory (activeRoom: HMRoom?, activeHome: HMHome?) {
        let accessory = accessories[0]
    
        if let activeRoom = activeRoom {
            if let activeHome = activeHome {
                activeHome.addAccessory(accessory, completionHandler: { (error) -> Void in
                    if error != nil {
                        print("Something went wrong when attempting to add an accessory to \(activeHome.name). \(error!.localizedDescription)")
                    } else {
                        activeHome.assignAccessory(accessory, toRoom: activeRoom, completionHandler: { (error) -> Void in
                            if error != nil {
                                print("Something went wrong when attempting to add an accessory to \(activeRoom.name). \(error!.localizedDescription)")
                            } else {
                                
                            }
                        })
                        
                    }
                })
            }
        }
    }
    
    // MARK: - Home Delegate
    
    //homeManager finished loading the home data
    func homeManagerDidUpdateHomes(manager: HMHomeManager) {
        homes = manager.homes
        
        if let home = manager.primaryHome {
            primaryHome = home
        } else {
            initialHomeSetup("Home",roomName: "Room")
        }
        
        var index = 0
        for home in homes {
            if !home.rooms.isEmpty {
                currentHomeID = homes[index].uniqueIdentifier
                currentRoomID = homes[index].rooms[0].uniqueIdentifier
                break
            }
            index++
        }
        
        
        appDelegate.contextHandler!.homeID = currentHomeID
        appDelegate.contextHandler!.roomID = currentRoomID
        
        delegate?.hasLoadedData(true)
        
        if let block = accessoryBlock {
            block()
            accessoryBlock = nil
        }
    }
    
    func homeManager(manager: HMHomeManager, didAddHome home: HMHome) {
        homes.append(home)
        print(homes)
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
    
//    // MARK: - Accessory Delegate
//    
//    func accessoryBrowser(browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
//        accessories.append(accessory)
////        tableView.reloadData()
//    }
//    
//    func accessoryBrowser(browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
//        var index = 0
//        for item in accessories {
//            if item.name == accessory.name {
//                accessories.removeAtIndex(index)
//                break
//            }
//            ++index
//        }
////        tableView.reloadData()
//    }
}