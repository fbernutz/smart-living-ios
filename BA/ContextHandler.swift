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
    
    //    Views -> VC (mit weak reference zu CH) -> ContextHandler (strong reference zu Services) -> Services
    //    ContextHandler: speichert Daten, ist immer erreichbar, besitzt auch den HomeManager(), locationManager()...
    //    AppDelegate legt den ContextHandler an
    //    über Notifications -> willBecomeActive usw.
    
    var homeKitController = HomeKitController()
    var homeKitHomeNames : [String]?
    var notifObserverTokens : [NSObjectProtocol]?
    
    var homeKitHomes : [HMHome]? {
        didSet {
            homeKitHomeNames = []
            for elem in homeKitHomes! {
                homeKitHomeNames!.append(elem.name)
            }
            
        }
    }
    
    override init() {
        super.init()
        
        prepareObservers()
    }
    
    //speichern vom der id vom aktuellen home und room usw.
    //vc fragt nach accessories -> leitet weiter an ch -> gib accessories von homekit für home id und room id  -> ch bekommt accessories (name,id und enums )

    //retrieve accessories
    
    
    func loadHomeKitData() {
        homeKitController.setupHomeController()
        
    }
    
    func prepareObservers() {
        
        notifObserverTokens = []
        
        let notifCenter = NSNotificationCenter.defaultCenter()
        
        notifObserverTokens?.append(notifCenter.addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil, queue: NSOperationQueue.mainQueue())
            { [ weak self] (notif) -> Void in
                
                self?.loadHomeKitData()
                
            })
    }
    
}