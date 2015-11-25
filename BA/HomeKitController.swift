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
    
    var homeManager = HMHomeManager()
    var primaryHome: HMHome?
    var rooms = [HMRoom]()
    var accessories = [HMAccessory]()
    let accessoryBrowser = HMAccessoryBrowser()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var homes = [HMHome]() {
        didSet {
            appDelegate.contextHandler?.homeKitHomes = homes
        }
    }
    
    // MARK: - Setup
    
    func setupHomeController() {
        
        homeManager.delegate = self
//        accessoryBrowser.delegate = self
        
        if homeManager.homes.count == 0 {
            initialHomeSetup("Name", roomName: "1")
        }
    }
    
    //retrieve home with id func
    //retrieve room with id func 
    //id von home und room speichern
    //retrieve accessoriesInRoom
    //accessories for room with id func -> accessory zurück (mitgeben welchen service man braucht -> licht oder garage opener)
    
    //Create first Home as Primary Home and first Room
    func initialHomeSetup (homeName: String, roomName: String) {
        homeManager.addHomeWithName(homeName) { home, error in
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
        homeManager.addHomeWithName(withName) { home, error in
            if let error = error {
                print("Something went wrong when attempting to create our home. \(error.localizedDescription)")
            } else {
                // TODO
//                home?.uniqueIdentifier
                
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
    
    // MARK: - Home Delegate
    
    //homeManager finished loading the home data
    func homeManagerDidUpdateHomes(manager: HMHomeManager) {
        homes = manager.homes
        
        if let home = manager.primaryHome {
            primaryHome = home
        } else {
            initialHomeSetup("Home",roomName: "Room")
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
}