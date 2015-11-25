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
        
        backgroundColor = Colours.lightBlue()
        
        setTitleColor(Colours.white(), forState: .Normal)
        
//        titleLabel?.font = UIFont.systemFontOfSize(14)
        titleLabel?.numberOfLines = 0
        
//        titleEdgeInsets = UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)
//        imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
//        layer.borderColor = Colours.lightBlue().CGColor
//        layer.borderWidth = 1.0
        
        contentHorizontalAlignment = .Center
        contentEdgeInsets = UIEdgeInsetsMake(8, 20, 8, 20)
        
        
//        let borderAlpha : CGFloat = 0.7
//        let cornerRadius : CGFloat = 5.0
//        
//        frame = CGRectMake(100, 100, 200, 40)
////        setTitle("Get Started", forState: UIControlState.Normal)
//        setTitleColor(Colours.white(), forState: UIControlState.Normal)
//        backgroundColor = UIColor.clearColor()
//        layer.borderWidth = 1.0
//        layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).CGColor
//        layer.cornerRadius = cornerRadius
        
    }

}
