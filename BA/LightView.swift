//
//  LightView.swift
//  BA
//
//  Created by Felizia Bernutz on 15.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class LightView: AccView {
    
    @IBOutlet weak var cView: UIView?
    @IBOutlet weak var infotext: UILabel?
    @IBOutlet weak var slider: UISlider?
    @IBOutlet weak var icon: UIImageView?
    @IBOutlet weak var stateSwitch: UISwitch?
    @IBOutlet weak var brightness: UILabel?
    
    var delegate : AccViewDelegate?
    
    @IBAction override func changeValueOfSlider(_ sender: UISlider) {
        delegate?.accViewSliderChanged(sender.value)
    }
    
    @IBAction override func changedValueOfSwitch(_ sender: UISwitch) {
        delegate?.accViewSwitchTapped(sender.isOn)
    }
    
}
