//
//  CustomButton.swift
//  BA
//
//  Created by Felizia Bernutz on 29.10.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.Custom.lightBlue

        setTitleColor(UIColor.Custom.white, for: UIControlState())

        titleLabel?.numberOfLines = 0

        contentHorizontalAlignment = .center
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    }

}
