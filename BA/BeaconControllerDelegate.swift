//
//  BeaconControllerDelegate.swift
//  BA
//
//  Created by Felizia Bernutz on 23.01.16.
//  Copyright (c) 2015 Felizia Bernutz. All rights reserved.
//

protocol BeaconControllerDelegate {
    
    func beaconFound(manager: BeaconController, major: Int, minor: Int)
    
}
