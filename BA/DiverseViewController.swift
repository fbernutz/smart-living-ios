//
//  DiverseViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 17.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DiverseViewController: UIViewController {

    @IBOutlet var diverseView: DiverseView?
    
    var accessory : IAccessory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diverseView!.infotext?.text = accessory?.name ?? "Test"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
