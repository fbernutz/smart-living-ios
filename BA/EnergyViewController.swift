//
//  EnergyViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 17.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class EnergyViewController: UIViewController {

    @IBOutlet var energyView: EnergyView?
    
    var accessory : IAccessory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        energyView?.powerConsumption?.text = accessory?.name ?? "Test"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
