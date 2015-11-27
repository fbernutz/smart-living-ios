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
    
    // TODO: Speichern der ID vom aktuellen Home und Room usw.
    var homeID : NSUUID?
    var roomID : NSUUID?
    
    var homeKitController : HomeKitController?
    var homeKitHomeNames : [String]?
    
    var homeKitHomes : [HMHome]? {
        didSet {
            homeKitHomeNames = []
            for elem in homeKitHomes! {
                homeKitHomeNames!.append(elem.name)
            }
        }
    }
    
    var localHomes : [Home]? {
        didSet {
            
        }
    }
    
    override init() {
        super.init()
        
        if homeKitController == nil {
            homeKitController = HomeKitController()
        }
        
        homeID = homeKitController!.retrieveHomeWithID()
        roomID = homeKitController!.retrieveRoomWithID()
    }
    
    // such den Namen für die gespeicherte homeID
    func retrieveHome(forID : NSUUID?) -> String? {
        
        //VERSION1
        if let locals = localHomes {
            for homes in locals {
                if homes.id == forID {
                    return homes.name
                }
            }
        }
        
        
        //VERSION2
        //        let homeName = homeKitController.homeHelper.localHomes?[0].name
        
        
        //VERSION3
        //        if localHomes != nil {
        //            let homeName = localHomes![0].name
        //            return homeName!
        //        } else {
        //            return nil
        //        }
        
        return nil
    }
    
    
    //    func retrieveAccessories() {
    //        //gib alle Accessories für das Home>Room aus
    //        //homeID: NSUUID?, roomID: NSUUID?
    //
    //    }
    
}