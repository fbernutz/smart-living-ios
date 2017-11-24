//
//  FAQCell.swift
//  BA
//
//  Created by Felizia Bernutz on 25.01.16.
//  Copyright © 2016 Felizia Bernutz. All rights reserved.
//

import UIKit

class FAQCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel?
    @IBOutlet weak var answerLabel: UILabel?

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCollapsed(_ isCollapsed: Bool) {
//        showInformation(isCollapsed)
    }

//    func showInformation(show: Bool) {
//        if show {
//            answerLabel?.hidden = false
//            if let const = bottomConstraint {
//                NSLayoutConstraint.activateConstraints([ const ])
//            }
//        } else {
//            answerLabel?.hidden = true
//            if let const = bottomConstraint {
//                NSLayoutConstraint.deactivateConstraints([ const ])
//            }
//        }
//    }

}
