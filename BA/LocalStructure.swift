//
//  Home.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import Foundation

public class Home: NSObject {
    var id : NSUUID?
    var name : String?
    var primary : Bool?
    
    init(id: NSUUID?, name: String?, primary: Bool?) {
        self.id = id
        self.name = name
        self.primary = primary
    }
}

public class Room: NSObject {
    var homeID : NSUUID?
    var id : NSUUID?
    var name : String?
    
    init(homeID: NSUUID?, id: NSUUID?, name: String?) {
        self.homeID = homeID
        self.id = id
        self.name = name
    }
}

public class Accessory : NSObject {
    var id : NSUUID?
    var name : String?
    var type : String?
    
    init(id: NSUUID?, name: String?, type: String?) {
        self.id = id
        self.name = name
        self.type = type
    }
}


//public class Characteristic : NSObject {
//    var status : Bool?
//    var brightness : Int?
//    
//}
//
//public class ActionSet : NSObject {
//    
//}
//
//public class Zones : NSObject {
//    
//}
//
//public class Trigger : NSObject {
//    
//}
//
//public class Beacon : NSObject {
//    
//}