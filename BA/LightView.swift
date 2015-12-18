//
//  LightView.swift
//  BA
//
//  Created by Felizia Bernutz on 15.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class LightView: UIView {
    
    @IBOutlet weak var infotext: UILabel?
    @IBOutlet weak var slider: UISlider?
    @IBOutlet weak var statusBtn: UIButton?
    @IBOutlet weak var icon: UIImageView?
    
    @IBAction func changeValueOfSlider(sender: UISlider) {
        print("value changed to: \(Int(sender.value))")
        
    }
    
//    var accessory : IAccessory? {
//        didSet {
//            infotext?.text = accessory!.name
//            
//            if let brightness = accessory?.characteristicProperties.brightness {
//                slider?.value = brightness
//            }
//        }
//    }

}
