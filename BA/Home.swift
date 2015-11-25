//
//  Home.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import Foundation

public class Home: NSObject {
    var name : String?
    var primary : Bool?
    var id : NSUUID?
    
//    var accessories : rooms.accessories?
    
}

public class Room: NSObject {
    var name : String?
    var id : NSUUID?
    
//    var icon : 
//    var categoryName : String? 
    
//    var accessories : [Accessory]?

}

public class Accessory : NSObject {
    var id : Int?
    var name : String?
    
//    var icon : 
//    var categoryName : String?
    
    var characteristics : [Characteristic]?

}


public class Characteristic : NSObject {
    var status : Bool?
    var brightness : Int?
    
    var accessory : Accessory?
    
}

public class ActionSet : NSObject {
    
}

public class Zones : NSObject {
    
}

public class Trigger : NSObject {
    
}

public class Beacon : NSObject {
    
}