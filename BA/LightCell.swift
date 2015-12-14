//
//  LightView.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class LightCell: UITableViewCell {
    
    @IBOutlet weak var infotext: UILabel?
    @IBOutlet weak var slider: UISlider?
    @IBOutlet weak var statusBtn: UIButton?
    @IBOutlet weak var icon: UIImageView?
    
    @IBAction func changeValueOfSlider(sender: UISlider) {
        print("value changed to: \(sender.value)")
        
    }
    
    var accessory : IAccessory? {
        didSet {
            infotext?.text = accessory!.name
            
            if let brightness = accessory?.characteristicProperties.brightness {
                slider?.value = brightness
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
}
