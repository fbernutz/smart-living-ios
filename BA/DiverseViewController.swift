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
    
    var contextHandler: ContextHandler?
    
    var accessory : AccessoryItem? {
        didSet {
            if accessory?.characteristics != nil {
                characteristics = accessory!.characteristics
            }
            
            reachable = accessory?.reachable
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
    
    var reachable: Bool?
    
    var serviceName : String? {
        didSet {
            if let _ = diverseView {
                setName(serviceName)
            }
        }
    }
    
    var size : CGFloat?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let reachable = reachable {
            if reachable {
                if let chars = characteristics {
                    if !chars.isEmpty {
                        print(">>>setCharacteristics: \(chars) for accessory: \((accessory!.name)!)")
                        setCharacteristics()
                    }
                }
            } else {
                setName("Momentan nicht erreichbar")
            }
            
            let _ = contextHandler!.homeKitController!.completedAccessoryView(accessory!)
        }
        
        size = diverseView!.cView!.frame.size.height
    }
    
    // MARK: - Set Values in LightView
    
    func setCharacteristics() {
        setService(serviceName)
        setName(accessory?.name)
    }
    
    func setService(_ name: String?) {
        if let _ = serviceName {
            diverseView?.serviceName?.isHidden = false
            diverseView?.serviceName?.text = name
        } else {
            diverseView?.serviceName?.isHidden = true
        }
    }
    
    func setName(_ name: String?) {
        if let name = name {
            diverseView?.infotext?.isHidden = false
            diverseView?.infotext?.text = name
        } else {
            diverseView?.infotext?.isHidden = true
        }
    }
    
}
