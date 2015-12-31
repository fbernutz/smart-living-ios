//
//  LightViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 10.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class LightViewController: UIViewController {
    
    @IBOutlet var lightView: LightView?
    
    var accessory : IAccessory? {
        didSet {
//            lightView?.infotext?.text = accessory?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lightView?.infotext?.text = accessory?.name ?? "Test"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
