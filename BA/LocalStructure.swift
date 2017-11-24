//
//  Home.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

open class Home: NSObject {
    var id: UUID?
    var name: String?
    var primary: Bool?

    init(id: UUID?, name: String?, primary: Bool?) {
        self.id = id
        self.name = name
        self.primary = primary
    }
}

open class Room: NSObject {
    var homeID: UUID?
    var id: UUID?
    var name: String?

    init(homeID: UUID?, id: UUID?, name: String?) {
        self.homeID = homeID
        self.id = id
        self.name = name
    }
}
