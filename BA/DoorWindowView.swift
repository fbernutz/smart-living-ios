//
//  DoorWindowView.swift
//  BA
//
//  Created by Felizia Bernutz on 17.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DoorWindowView: AccView {

    var delegate : AccViewDelegate?
    
    @IBOutlet weak var infotext: UILabel?
    @IBOutlet weak var stateChangedTime: UILabel?
    @IBOutlet weak var doorStateBtn: UIButton?
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    
    @IBAction override func changeValueOfButton(sender: UIButton) {
        delegate?.accViewButtonTapped((sender.titleLabel?.text)!)
    }
}
