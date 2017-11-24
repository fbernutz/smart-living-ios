//
//  PageViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 25.01.16.
//  Copyright © 2016 Felizia Bernutz. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView?

    var itemIndex: Int = 0

    var imageName: String = "" {
        didSet {
            if let imageView = imageView {
                imageView.image = UIImage(named: imageName)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView!.image = UIImage(named: imageName)
    }
}
