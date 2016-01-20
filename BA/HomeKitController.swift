//
//  HomeViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 09.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit
import HomeKit

class HomeKitController: NSObject, HMHomeManagerDelegate, HMAccessoryBrowserDelegate, HMAccessoryDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var contextHandler : ContextHandler?
    var delegate: HomeKitControllerDelegate?
    var accessoryDelegate : HomeKitControllerNewAccessoriesDelegate?
    
    var homeManager = HMHomeManager()
    var accessoryBrowser = HMAccessoryBrowser()
    var homeKitAccessories : [HMAccessory]?
    lazy var homeHelper = HomeHelper()
    lazy var accessoryFactory = AccessoryFactory()
    var services = [HMService]()
    
    var primaryHome: HMHome?
    
    var currentHomeID : NSUUID? {
        didSet {
            contextHandler?.homeID = currentHomeID
        }
    }
    
    var currentRoomID : NSUUID? {
        didSet {
            contextHandler?.roomID = currentRoomID
        }
    }
    
    var homes = [HMHome]()
    
    var rooms = [HMRoom]() {
        didSet {
            
            // TODO: wenn ein Service Room neu erstellt wird, Umwandlung in lokale Struktur nochmal überarbeiten - noch falsch
            // homeHelper?.serviceToLocalRooms(homes)
        }
    }
    
    var pairedAccessories : [IAccessory]? = [] {
        didSet {
            print("HomeKitController: \(pairedAccessories!)")
            contextHandler?.pairedAccessories = pairedAccessories!
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
        homeKitAccessories = homes.filter({ $0.uniqueIdentifier == homeID }).first?.rooms.filter({ $0.uniqueIdentifier == roomID }).first?.accessories
        
        if homeKitAccessories != nil {
            let localPairedAccessories: [IAccessory]? = homeKitAccessories!.map{createIAccessory($0)}
            
            if let pairedAccessories = localPairedAccessories {
                if !pairedAccessories.isEmpty {
                    for var acc in pairedAccessories {
                        if acc.characteristics.isEmpty {
                            acc.characteristicBlock = { () in
                                acc.characteristics = acc.getCharacteristics()!
                                //                            print(acc.characteristics)
                                self.pairedAccessories = pairedAccessories
                                dispatch_async(dispatch_get_main_queue()) {
                                    completionHandler(self.pairedAccessories!)
                                }
                            }
                        }
                    }
                } else {
                    self.pairedAccessories = []
                    completionHandler(self.pairedAccessories!)
                }
            }
        }
        
    }
    
    func createIAccessory(homeKitAccessory: HMAccessory) -> IAccessory {
        var service : HMService?
        let name = homeKitAccessory.name
        
        if name.rangeOfString("Eve") != nil {
            for hmservice in homeKitAccessory.services {
                if (hmservice.serviceType == HMServiceTypeOutlet) || (hmservice.serviceType == "E863F003-079E-48FF-8F27-9C2605A29F52") || (hmservice.serviceType == "E863F001-079E-48FF-8F27-9C2605A29F52") {
                    service = hmservice
                }
            }
        } else {
            service = homeKitAccessory.services.last!
        }
        
        var newAcc = accessoryFactory.accessoryForServices(service!, name: name)!
        newAcc.name = name
        newAcc.uniqueID = homeKitAccessory.uniqueIdentifier
        newAcc.retrieveCharacteristics(service!)
        
        homeKitAccessory.delegate = self
        
        return newAcc
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
        let arrayOfIAccessories = unpairedAccessories.map({ accessoryFactory.accessoryForServices($0.services[1], name: $0.name)! })
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
        
        let homeWithoutRoom = homes.filter{ $0.rooms.isEmpty }
        
        // If one of them is still empty, create one default home and room
        if homes.isEmpty || rooms.isEmpty {
            initialHomeSetup("Default Home", roomName: "Default Room")
        } else if !homeWithoutRoom.isEmpty {
            for home in homeWithoutRoom {
                initialHomeSetup(home.name, roomName: "Default Room")
            }
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
//                self.accessoryFactory.accessories = self.homes.filter({ $0.uniqueIdentifier == homeID }).first?.rooms.filter({ $0.uniqueIdentifier == roomID }).first?.accessories
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
                    home!.addRoomWithName(roomName) { room, error in
                        if let error = error {
                            print("Something went wrong when attempting to create our home. \(error.localizedDescription)")
                        } else {
                            self.delegate?.hasCreatedDefaultHomes("Keine Daten gefunden", message: "Es wurde ein neues Zuhause mit einem neuen Raum erstellt.")
                            
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
                                self.delegate?.hasCreatedDefaultHomes("Kein Raum im Home >\(home.name)< gefunden", message: "Es wurde ein neuer Raum in >\(home.name)< erstellt.")
                                
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
    
    func accessory(accessory: HMAccessory, service: HMService, didUpdateValueForCharacteristic characteristic: HMCharacteristic) {
        print(characteristic.value)
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
                        var newAccessory = self.createIAccessory(homeKitAccessory)
                        
                        if newAccessory.characteristics.isEmpty {
                            newAccessory.characteristicBlock = { () in
                                newAccessory.characteristics = newAccessory.getCharacteristics()!
                                print(newAccessory.characteristics)
                                self.pairedAccessories!.append(newAccessory)
                                completionHandler()
                            }
                        }
                    }
                })
                
            }
        })
    }
    
    
    func getHMAccessory(accessory: IAccessory) -> HMAccessory {
        return (homeKitAccessories?.filter { ($0.uniqueIdentifier == accessory.uniqueID) }.first)!
    }
    
    func setNewValues(accessory: IAccessory, characteristic: [CharacteristicKey : AnyObject]) {
        var hmCharacteristic: HMCharacteristic?
        let hmAccessory : HMAccessory?
        let characteristicKey : CharacteristicKey?
        let characteristicValue : AnyObject
        let hmService : HMService?
        
        //unique id
        hmAccessory = getHMAccessory(accessory)
        
        //characteristic type
        characteristicKey = characteristic.map{ $0.0 }.first!
        
        //characteristic value
        characteristicValue = characteristic.map{ $0.1 }.first!
        
        //service
        hmService = hmAccessory!.services.last

        
//        for char in hmService!.characteristics {
//            switch characteristicKey! {
//            case .brightness:
//                if char.characteristicType == (HMCharacteristicTypeBrightness as String) {
//                    hmCharacteristic = char
//                }
//            case .powerState:
//                if char.characteristicType == (HMCharacteristicTypePowerState as String) {
//                    hmCharacteristic = char
//                }
//            case .serviceName:
//                if char.characteristicType == (HMCharacteristicTypeName as String) {
//                    hmCharacteristic = char
//                }
//            }
//        }
        
        //setCharacteristics
        accessory.setCharacteristic(hmService!, characteristicKey: characteristicKey!, value: characteristicValue)
        
    }
    
    
    
    
    
    
    
    
}