//
//  BeaconControllerDelegate.swift
//  BA
//
//  Created by Felizia Bernutz on 23.01.16.
//  Copyright (c) 2015 Felizia Bernutz. All rights reserved.
//

protocol ContextHandlerDelegate {
    
    func roomForBeacon(_ manager: ContextHandler, connectorArray: [BeaconRoomConnector], major: Int, minor: Int)
    
}
