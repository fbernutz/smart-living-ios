//
//  EnergyViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 17.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class EnergyViewController: UIViewController, AccViewDelegate {

    @IBOutlet var energyView: EnergyView?
    
    var contextHandler: ContextHandler?
    
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
                    print("set Characteristics in VC: \((accessory?.name)!)")
                    serviceName = chars.filter{ $0.0 == CharacteristicKey.serviceName }.first.map{ $0.1 as! String }
                    state = chars.filter{ $0.0 == CharacteristicKey.powerState }.first.map{ $0.1 as! Bool }
                }
            }
        }
    }
    
    var serviceName : String? {
        didSet {
            if let _ = energyView {
                setName(serviceName)
            }
        }
    }
    
    var state : Bool? {
        didSet {
            if let _ = energyView {
                setPowerState(state)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        energyView!.delegate = self
        
        energyView!.loadingIndicator!.startAnimating()
        
        if let chars = characteristics {
            if !chars.isEmpty {
                print(">>>setCharacteristics: \(chars) for accessory: \((accessory!.name)!)")
                setCharacteristics()
                energyView!.loadingIndicator!.stopAnimating()
            }
        }
    }
    
    // MARK: - Set Values in LightView
    
    func setCharacteristics() {
        setService(nil)
        setName(accessory?.name)
        setPowerState(state)
    }
    
    func setService(name: String?) {
        if let _ = serviceName {
            //            lightView!.infotext!.text = name
        } else {
            //            lightView!.infotext!.text = "Not Found"
        }
    }
    
    func setName(name: String?) {
        if let name = name {
            energyView!.infotext!.text = name
        } else {
            energyView!.infotext!.text = "Not Found"
        }
    }
    
    func setPowerState(state: Bool?) {
        if let state = state {
            energyView!.powerState!.hidden = false
            energyView!.powerState!.enabled = true
            energyView!.powerState!.setOn(state, animated: false)
        } else {
            energyView!.powerState!.hidden = true
            energyView!.powerState!.enabled = false
        }
    }
    
    // MARK: - AccViewDelegate
    
    func accViewSwitchTapped(state: Bool) {
        contextHandler!.homeKitController!.setNewValues(accessory!, characteristic: [.powerState:state])
    }
    
    func accViewSliderChanged(value: Float) {
    }
    
    func accViewButtonTapped(state: String) {
    }

}
