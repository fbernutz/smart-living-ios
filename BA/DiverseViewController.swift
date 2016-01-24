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
    
    var accessory : IAccessory? {
        didSet {
            if accessory?.characteristics != nil {
                characteristics = accessory!.characteristics
            }
        }
    }
    
    var characteristics : [CharacteristicKey:AnyObject]? {
        didSet {
            if let chars = characteristics {
                if !chars.isEmpty {
                    serviceName = chars.filter{ $0.0 == CharacteristicKey.serviceName }.first.map{ $0.1 as! String }
                }
            }
        }
    }
    
    var serviceName : String? {
        didSet {
            if let _ = diverseView {
                setName(serviceName)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diverseView!.loadingIndicator!.startAnimating()
        
        if let chars = characteristics {
            if !chars.isEmpty {
                print(">>>setCharacteristics: \(chars) for accessory: \((accessory!.name)!)")
                setCharacteristics()
                diverseView!.loadingIndicator!.stopAnimating()
            }
        }
    }
    
    // MARK: - Set Values in LightView
    
    func setCharacteristics() {
        setService(serviceName)
        setName(accessory?.name)
    }
    
    func setService(name: String?) {
        if let _ = serviceName {
            diverseView!.serviceName!.text = name
        } else {
            diverseView!.serviceName!.text = "Not Found"
        }
    }
    
    func setName(name: String?) {
        if let name = name {
            diverseView!.infotext!.text = name
        } else {
            diverseView!.infotext!.text = "Not Found"
        }
    }
    
}
