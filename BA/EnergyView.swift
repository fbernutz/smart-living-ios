//
//  EnergyView.swift
//  BA
//
//  Created by Felizia Bernutz on 17.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class EnergyView: AccView {
    
    var delegate : AccViewDelegate?
    
    @IBOutlet weak var cView: UIView?
    @IBOutlet weak var infotext: UILabel?
    @IBOutlet weak var powerConsumptionText: UILabel?
    @IBOutlet weak var powerState: UISwitch?
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    
    @IBAction override func changedValueOfSwitch(sender: UISwitch) {
        delegate?.accViewSwitchTapped(sender.on)
    }
}
