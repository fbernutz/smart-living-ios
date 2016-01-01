//
//  LightView.swift
//  BA
//
//  Created by Felizia Bernutz on 15.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class LightView: UIView {
    
    var delegate : LightViewDelegate?
    
    @IBOutlet weak var infotext: UILabel?
    @IBOutlet weak var slider: UISlider?
    @IBOutlet weak var icon: UIImageView?
    @IBOutlet weak var stateSwitch: UISwitch?
    
    @IBAction func changeValueOfSlider(sender: UISlider) {
        delegate?.lightViewSliderChanged(sender.value)
    }
    
    @IBAction func changedValueOfSwitch(sender: UISwitch) {
        delegate?.lightViewSwitchTapped(sender.on)
    }
    
}
