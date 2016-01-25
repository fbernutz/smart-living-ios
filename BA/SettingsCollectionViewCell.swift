//
//  SettingsCollectionViewCell.swift
//  BA
//
//  Created by Felizia Bernutz on 25.01.16.
//  Copyright © 2016 Felizia Bernutz. All rights reserved.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel?
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                self.layer.opacity = 0.5
            } else {
                self.layer.opacity = 1.0
            }
        }
    }
    
}
