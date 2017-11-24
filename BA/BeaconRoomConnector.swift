//
//  BeaconRoomController.swift
//  BA
//
//  Created by Felizia Bernutz on 23.01.16.
//  Copyright (c) 2015 Felizia Bernutz. All rights reserved.
//

import Foundation

class BeaconRoomConnector {

    let major: Int
    let minor: Int
    let home: String
    let room: String

    init (major: Int, minor: Int, home: String, room: String) {
        self.major = major
        self.minor = minor
        self.home = home
        self.room = room
    }

    init (dict: NSDictionary) {
        self.major = dict["major"] as! Int
        self.minor = dict["minor"] as! Int
        self.home = dict["home"] as! String
        self.room = dict["room"] as! String
    }

    var description: String {
        return "Major: \(major), Minor: \(minor), Home: \(home), Room: \(room)"
    }

    func dictionaryForEntity() -> NSDictionary {
        return [ "major": major, "minor": minor, "home": home, "room": room ]
    }

}
