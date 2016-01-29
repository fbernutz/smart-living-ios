//
//  Colours.swift
//  BA
//
//  Created by Felizia Bernutz on 29.10.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class Colours  {
    
    //black: 14,17,22
    class func black() -> UIColor {
        return UIColor(red: 14.0 / 255.0, green: 17.0 / 255.0, blue: 22.0 / 255.0, alpha: 1.0)
    }
    
    //hellgelb: 244,226,133
    class func lightYellow() -> UIColor {
        return UIColor(red: 244.0 / 255.0, green: 226.0 / 255.0, blue: 133.0 / 255.0, alpha: 1.0)
    }
    
    //gelb: 226,192,68 -> Buttons
    class func yellow() -> UIColor {
        return UIColor(red: 226.0 / 255.0, green: 192.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0)
    }
    
    //hellblau: 88,123,127 -> Navi
    class func lightBlue() -> UIColor {
        return UIColor(red: 88.0 / 255.0, green: 123.0 / 255.0, blue: 127.0 / 255.0, alpha: 1.0)
    }
    
    //dunkelblau: 55,74,103 -> Hervorhebung im Text
    class func blue() -> UIColor {
        return UIColor(red: 55.0 / 255.0, green: 74.0 / 255.0, blue: 103.0 / 255.0, alpha: 1.0)
    }
    
    //white
    class func white() -> UIColor {
        return UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    //white
    class func lightGray() -> UIColor {
        return UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
    
}
