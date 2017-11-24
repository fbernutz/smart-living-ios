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

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var contextHandler: ContextHandler?
    var delegate: HomeKitControllerDelegate?
    var accessoryDelegate: HomeKitControllerNewAccessoriesDelegate?

    var homeManager = HMHomeManager()
    var accessoryBrowser = HMAccessoryBrowser()
    var homeKitAccessories: [HMAccessory]?
    lazy var homeHelper = HomeHelper()
    lazy var accessoryFactory = AccessoryFactory()
    var services = [HMService]()

    var dictKeyToHomeKitType: [CharacteristicKey : String]?

    var primaryHome: HMHome?

    var homes = [HMHome]()
    var rooms = [HMRoom]()

    var beaconHome: HMHome?
    var beaconRoom: HMRoom?

    var currentHomeID: UUID?
    var currentRoomID: UUID?

    var pairedAccessories: [AccessoryItem]? = [] {
        didSet {
            print("HomeKitController: \(pairedAccessories!)")
            contextHandler?.pairedAccessories = pairedAccessories!
        }
    }

    var unpairedAccessories = [HMAccessory]()

    var accessoryBlock : (() -> Void)?

    // MARK: - Setup

    override init() {
        super.init()

        homeManager.delegate = self
        accessoryBrowser.delegate = self
        homeHelper.homeKitController = self

        dictKeyToHomeKitType = [.brightness: HMCharacteristicTypeBrightness,
            .powerState: HMCharacteristicTypePowerState,
            .serviceName: HMCharacteristicTypeName,
            .temperature: HMCharacteristicTypeTemperatureUnits,
            .humidity: HMCharacteristicTypeTargetRelativeHumidity,
            .doorState: HMCharacteristicTypeTargetDoorState]
    }

    // MARK: - Start and stop searching for new accessories

    func startSearchingForAccessories() {
        accessoryBrowser.startSearchingForNewAccessories()
    }

    func stopSearching() {
        accessoryBrowser.stopSearchingForNewAccessories()
    }

    func discoveredAccessories() -> [String] {
        return accessoryBrowser.discoveredAccessories.map { $0.name }
    }

    // MARK: - Retrieve AccessoryItem

    func retrieveAccessoriesForRoom(inHome homeID: UUID, roomID: UUID, completionHandler: @escaping ()->Void) {
        var localPairedAccessories: [AccessoryItem] = []
        var accessoryViews: [Bool] = []

        currentHomeID = homeID
        currentRoomID = roomID

        if !homes.isEmpty {

            getAccessoryItems(roomID, inHome: homeID) { accessory in

                if let acc = accessory {
                    localPairedAccessories.append(acc)
                    accessoryViews.append(self.completedAccessoryView(acc))
                } else {
                    completionHandler()
                }

                if self.homeKitAccessories?.count == localPairedAccessories.count {
                    self.pairedAccessories = localPairedAccessories

                    if !accessoryViews.contains(false) {
                        completionHandler()
                    }
                }
            }
        } else {
            accessoryBlock = { () in
                self.getAccessoryItems(roomID, inHome: homeID) { accessory in

                    if let acc = accessory {
                        localPairedAccessories.append(acc)
                        accessoryViews.append(self.completedAccessoryView(acc))
                    } else {
                        completionHandler()
                    }

                    if self.homeKitAccessories?.count == localPairedAccessories.count {
                        self.pairedAccessories = localPairedAccessories

                        if !accessoryViews.contains(false) {
                            completionHandler()
                        }
                    }
                }
            }
        }
    }

    fileprivate func getAccessoryItems(_ roomID: UUID, inHome homeID: UUID, completionHandler : @escaping (AccessoryItem?) -> Void) {
        var hmService: HMService?

        //1 find HMAccessories in this room
        homeKitAccessories = homes.filter { $0.uniqueIdentifier == homeID }.first?.rooms.filter { $0.uniqueIdentifier == roomID }.first?.accessories

        if let hmAccessories = homeKitAccessories {
            if !hmAccessories.isEmpty {
                //2 create AccessoryItems for found HMAccessories
                let localPairedAccessories: [AccessoryItem] = hmAccessories.map { createAccessoryItem($0) }

                for var acc in localPairedAccessories {

                    //3 find HMService for AccessoryItem
                    let hmAcc = getHMAccessory(acc)
                    hmService = retrieveHMService(hmAcc)

                    //4 the search for characteristics starts here
                    acc.retrieveCharacteristics(hmService!)

                    loadCharacteristicForAccessory(acc, completionHandler: completionHandler)
                }
            } else {
                completionHandler(nil)
            }
        } else {
            homeKitAccessories = []
            completionHandler(nil)
        }
    }

    func createAccessoryItem(_ homeKitAccessory: HMAccessory) -> AccessoryItem {
        var hmService: HMService?
        let hmName = homeKitAccessory.name

        //set delegate to detect changes to HMAccessory
        homeKitAccessory.delegate = self

        hmService = retrieveHMService(homeKitAccessory)

        var newAcc = accessoryFactory.accessoryForServices(hmService!, name: hmName)!
        newAcc.name = hmName
        newAcc.uniqueID = homeKitAccessory.uniqueIdentifier
        newAcc.reachable = homeKitAccessory.isReachable

        return newAcc
    }

    func retrieveHMService(_ accessory: HMAccessory) -> HMService {

        if accessory.name.range(of: "Eve") != nil {
            for service in accessory.services {
                if (service.serviceType == HMServiceTypeOutlet) || (service.serviceType == "E863F003-079E-48FF-8F27-9C2605A29F52") || (service.serviceType == "E863F001-079E-48FF-8F27-9C2605A29F52") {
                    return service
                }
            }
        }

        return accessory.services.last!
    }

    fileprivate func getAccessoryItem(_ hmAccessory: HMAccessory) -> AccessoryItem? {
        return pairedAccessories!.filter { $0.uniqueID! as UUID == hmAccessory.uniqueIdentifier }.first
    }

    fileprivate func getHMAccessory(_ accessoryItem: AccessoryItem) -> HMAccessory {
        return homeKitAccessories!.filter { $0.uniqueIdentifier == accessoryItem.uniqueID }.first!
    }

    // MARK: - Home Functions

    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {

        //1 Set homes
        homes = manager.homes

        //2 Set rooms
        for home in homes {
            rooms += home.rooms
        }

        let homeWithoutRoom = homes.filter { $0.rooms.isEmpty }

        if homes.isEmpty || rooms.isEmpty {

            //3 if home or room is emtpy, create one default home and room
            initialHomeSetup("Default Home", roomName: "Default Room")

        } else if !homeWithoutRoom.isEmpty {

            //4 find home without room, create one default room
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
    }

    func homesAreSet() {
        if !homes.isEmpty {
            retrieveHomes(completionHandler: { homes in
                self.contextHandler!.localHomes = homes
            })
        } else {
            print ("Failed: Homes are not set yet or set to nil")
        }
    }

    func roomsAreSet() {
        if !rooms.isEmpty {
            retrieveRooms(homes, completionHandler: { rooms in
                self.contextHandler!.localRooms = rooms
            })

            retrieveCurrentHomeAndRoom { homeID, roomID in
                self.currentHomeID = homeID
                self.currentRoomID = roomID

                self.contextHandler!.homeID = homeID
                self.contextHandler!.roomID = roomID
            }

        } else {
            print ("Failed: Rooms are not set yet or set to nil")
        }
    }

    func retrieveHomes(completionHandler completion: (_ homes: [Home]) -> Void) {
        let localHome = homeHelper.serviceToLocalHomes(homes)
        completion(localHome!)
    }

    func retrieveRooms(_ homes: [HMHome], completionHandler completion: (_ rooms: [Room]) -> Void) {
        let localRooms = homeHelper.serviceToLocalRooms(homes)
        completion(localRooms!)
    }

    func retrieveCurrentHomeAndRoom(completionHandler completion: (_ homeID: UUID, _ roomID: UUID) -> Void) {
        let homeWithRoom = homes.filter { !$0.rooms.isEmpty }.first

        let homeID = homeWithRoom!.uniqueIdentifier
        let roomID = homeWithRoom!.rooms.first!.uniqueIdentifier

        completion(homeID, roomID)
    }

    // MARK: - HomeKit Delegates

    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        homes.append(home)
        homesAreSet()
    }

    func homeManager(_ manager: HMHomeManager, didAddRoom room: HMRoom) {
        rooms.append(room)
        roomsAreSet()
    }

    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        print("Did update home")
    }

    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        let index = homes.index { $0 == home }
        homes.remove(at: index!)
    }

    // MARK: - Accessory Delegate

    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        unpairedAccessories.append(accessory)
        accessoryDelegate?.hasLoadedNewAccessory(accessory.name, stillLoading: true)
    }

    func accessoryBrowser(_ browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        let index = unpairedAccessories.index { $0.name == accessory.name }
        unpairedAccessories.remove(at: index!)
    }

    // MARK: - HomeKit Methods

    func initialHomeSetup(_ homeName: String, roomName: String) {

        switch homes.count {
        case 0:
            //Create first home as primary home and first room
            homeManager.addHome(withName: homeName) { home, error in
                if let error = error {
                    print("Something went wrong when attempting to create our home. \(error.localizedDescription)")
                } else {
                    home!.addRoom(withName: roomName) { room, error in
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

            //Create first room for home without room
            for home in homes {
                if home.name == homeName {
                    if home.rooms.isEmpty {
                        home.addRoom(withName: roomName) { room, error in
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

    func addHome(_ withName: String) {
        homeManager.addHome(withName: withName) { _, error in
            if let error = error {
                print("Something went wrong when attempting to create our home. \(error.localizedDescription)")
            } else {
                //
            }
        }
    }

    func addRoom(_ withName: String, toHome: HMHome) {
        toHome.addRoom(withName: withName) { room, error in
            if let error = error {
                print("Something went wrong when attempting to create our room. \(error.localizedDescription)")
            } else {
                self.rooms.append(room!)
            }
        }
    }

    func updatePrimaryHome(_ home: HMHome) {
        homeManager.updatePrimaryHome(home) { error in
            if let error = error {
                print("Something went wrong when attempting to make this home our primary home. \(error.localizedDescription)")
            } else {
                self.primaryHome = home
            }
        }
    }

    func removeHome(_ home: HMHome) {
        homeManager.removeHome(home) { error in
            if let error = error {
                print ("Error: \(error)")
            } else {
                //
            }
        }
    }

    func addAccessory(_ accessoryName: String, activeHomeID: UUID, activeRoomID: UUID, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void ) {

        let homeKitAccessory = unpairedAccessories.filter { $0.name == accessoryName }.first!
        let activeHome = homes.filter { $0.uniqueIdentifier == activeHomeID }.first!
        let activeRoom = homes.filter { $0.uniqueIdentifier == activeHomeID }.first!.rooms.filter { $0.uniqueIdentifier == activeRoomID }.first!

        activeHome.addAccessory(homeKitAccessory, completionHandler: { error in
            if error != nil {
                print("Something went wrong when attempting to add an accessory to \(activeHome.name). \(error!.localizedDescription)")
                completionHandler(false, error as NSError?)
            } else {
                activeHome.assignAccessory(homeKitAccessory, to: activeRoom, completionHandler: { error in
                    if error != nil {
                        print("Something went wrong when attempting to add an accessory to \(activeRoom.name). \(error!.localizedDescription)")
                        completionHandler(false, error as NSError?)
                    } else {

                        //1 create a new AccessoryItem for paired HMAccessories
                        var newAccessory = self.createAccessoryItem(homeKitAccessory)

                        self.homeKitAccessories?.append(homeKitAccessory)

                        //2 for new AccessoryItem check if its characteristics is empty
                        if newAccessory.characteristics.isEmpty {
                            newAccessory.characteristicBlock = { () in

                                //3 get and save loaded characteristics
                                newAccessory.characteristics = newAccessory.getCharacteristics()!

                                //4 append new AccessoryItem with characteristics in pairedAccessories
                                self.pairedAccessories!.append(newAccessory)
                                completionHandler(true, nil)
                            }
                        } else {
                            //3 get and save loaded characteristics
                            newAccessory.characteristics = newAccessory.getCharacteristics()!

                            //4 append new AccessoryItem with characteristics in pairedAccessories
                            self.pairedAccessories!.append(newAccessory)
                            completionHandler(true, nil)
                        }

                        completionHandler(true, nil)
                    }
                })

            }
        })
    }

    // MARK: - Changed reachability

    func accessoryDidUpdateReachability(_ accessory: HMAccessory) {
        let accessoryItem = getAccessoryItem(accessory)

        if var acc = accessoryItem {
            if acc.reachable != accessory.isReachable {
                acc.reachable = accessory.isReachable

                let hmService = retrieveHMService(accessory)
                acc.retrieveCharacteristics(hmService)

                loadCharacteristicForAccessory(acc, completionHandler: { _ in

                    // save new loaded AccessoryItem in pairedAccessories
                    let index = self.pairedAccessories!.index { $0.uniqueID == acc.uniqueID }
                    self.pairedAccessories![index!] = acc

                })
            }
        }
    }

    // MARK: - Changed characteristic values

    func loadCharacteristicForAccessory(_ accessory: AccessoryItem, completionHandler: @escaping (AccessoryItem?) -> Void) {
        var accessory = accessory

        if accessory.reachable == false {
            completionHandler(accessory)
        } else {
            // for every AccessoryItem check if its characteristics is empty
            if accessory.characteristics.isEmpty {
                accessory.characteristicBlock = { () in
                    // get and save loaded characteristics
                    accessory.characteristics = accessory.getCharacteristics()!

                    // save accessories with characteristics in pairedAccessories
                    DispatchQueue.main.async {
                        completionHandler(accessory)
                    }
                }
            } else {
                // get and save loaded characteristics
                accessory.characteristics = accessory.getCharacteristics()!

                // save accessories with characteristics in pairedAccessories
                DispatchQueue.main.async {
                    completionHandler(accessory)
                }
            }
        }
    }

    func reloadAccessories(_ completionHandler: @escaping () -> Void) {
        var hmService: HMService?
        var localPairedAccessories: [AccessoryItem] = []
        var accessoryViews: [Bool] = []

        for var acc in pairedAccessories! {
            //1 find HMService for AccessoryItem
            let hmAcc = getHMAccessory(acc)
            hmService = retrieveHMService(hmAcc)

            //2 loading characteristic for AccessoryItem started
            acc.retrieveCharacteristics(hmService!)

            loadCharacteristicForAccessory(acc, completionHandler: { accessory in

                if let acc = accessory {
                    localPairedAccessories.append(acc)
                    accessoryViews.append(self.completedAccessoryView(acc))
                }

                if self.homeKitAccessories?.count == localPairedAccessories.count {
                    self.pairedAccessories = localPairedAccessories

                    if !accessoryViews.contains(false) {
                        completionHandler()
                    }
                }
            })

        }
    }

    func completedAccessoryView(_ accessory: AccessoryItem) -> Bool {
        return true
    }

    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {

        let key = dictKeyToHomeKitType!.filter { $0.1 == characteristic.characteristicType }.first.map { $0.0 }
        let value = characteristic.value as AnyObject

        //1 find AccessoryItem for HMAccessory
        var accessoryItem = getAccessoryItem(accessory)

        if key != nil && accessoryItem != nil {
            if value !== accessoryItem!.characteristics[key!] {

                //2 set new values for AccessoryItem
                accessoryItem!.characteristics[key!] = value as AnyObject?

                //3 write changed AccessoryItem to pairedAccessories
                let index = pairedAccessories!.index(where: { $0.uniqueID == accessoryItem!.uniqueID })
                pairedAccessories![index!] = accessoryItem!
            }
        }
    }

    func setNewValues(_ accessory: AccessoryItem, characteristic: [CharacteristicKey : AnyObject]) {

        let characteristicKey = characteristic.map { $0.0 }.first!
        var characteristicValue = characteristic.map { $0.1 }.first!

        //1 find HMAccessory for AccessoryItem
        let hmAccessory = getHMAccessory(accessory)

        //2 find HMCharacteristicType for CharacteristicKey
        let homeKitType = dictKeyToHomeKitType!.filter { $0.0 == characteristicKey }.first.map { $0.1 }

        //3 change CharacteristicValue to correct type
        if homeKitType == (HMCharacteristicTypeBrightness as String) {
            characteristicValue = characteristicValue as! Int as AnyObject
        } else if homeKitType == (HMCharacteristicTypePowerState as String) {
            characteristicValue = characteristicValue as! Bool as AnyObject
        }

        //4 find HMCharacteristic to write new value
        let hmService = hmAccessory.services.filter { ($0.serviceType == HMServiceTypeOutlet) || ($0.serviceType == HMServiceTypeLightbulb) }.first
        let characteristic = hmService!.characteristics.filter { $0.characteristicType == homeKitType }.first

        //5 write new value on HMCharacteristic
        characteristic!.writeValue(characteristicValue, completionHandler: { error in
            if let error = error {
                NSLog("Failed to update value \(error)")
            }
        })
    }

    // MARK: - Beacon Functions

    func findHMRoomForBeacon(_ home: String, room: String, completionHandler: (_ success: Bool, _ homeID: UUID?, _ roomID: UUID?) -> Void ) {

        //1 find HMHome for home name as beaconHome
        beaconHome = homes.filter { $0.name == home }.first

        if let bHome = beaconHome {

            //2 find HMRoom for room name as beaconRoom
            beaconRoom = bHome.rooms.filter { $0.name == room }.first

            if let bRoom = beaconRoom {

                //3 completionHandler: successfull, homeID and roomID
                completionHandler(true, bHome.uniqueIdentifier, bRoom.uniqueIdentifier)

            } else {
                completionHandler(false, bHome.uniqueIdentifier, nil)
            }
        } else {
            completionHandler(false, nil, nil)
        }

    }

}
