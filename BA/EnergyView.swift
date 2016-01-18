//
//  EnergyView.swift
//  BA
//
//  Created by Felizia Bernutz on 17.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class EnergyView: AccView {
    
    @IBOutlet weak var infotext: UILabel?
    @IBOutlet weak var powerConsumptionText: UILabel?
    @IBOutlet weak var powerState: UISwitch?
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    
    var delegate : AccViewDelegate?
    
    @IBAction override func changedValueOfSwitch(sender: UISwitch) {
        delegate?.accViewSwitchTapped(sender.on)
    }
}
