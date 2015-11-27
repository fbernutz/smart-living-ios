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
    var homeKitController : HomeKitController?
    
    override init() {
        super.init()
    }
    
    
    
    // MARK: - Conversions from localHomes to homeKitHomes and vice versa
    
    func serviceToLocal(homeKitHomes: [HMHome]) -> [Home]? {
        localHomes = []
        for home in homeKitHomes {
            localHomes?.append(Home(id: home.uniqueIdentifier, name: home.name, primary: home.primary))
        }
        return localHomes
    }
    
    func localToService(localHome: Home) {
        homeKitController?.addHome(localHome.name!)
    }
    
}