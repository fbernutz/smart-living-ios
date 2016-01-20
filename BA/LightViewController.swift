//
//  LightViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 10.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class LightViewController: UIViewController, AccViewDelegate {
    
    @IBOutlet var lightView: LightView?
    
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
                    brightnessValue = chars.filter{ $0.0 == CharacteristicKey.brightness }.first.map{ $0.1 as! Float }
                    state = chars.filter{ $0.0 == CharacteristicKey.powerState }.first.map{ $0.1 as! Bool }
                }
            }
        }
    }
    
    var serviceName : String? {
        didSet {
            if let _ = lightView {
                setName(serviceName)
            }
        }
    }
    var brightnessValue : Float? {
        didSet {
            if let _ = lightView {
                setBrightness(brightnessValue)
            }
        }
    }
    var state : Bool? {
        didSet {
            if let _ = lightView {
                setPowerState(state)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightView!.delegate = self
        
        lightView!.loadingIndicator!.startAnimating()
        
        if let chars = characteristics {
            if !chars.isEmpty {
                print(">>>setCharacteristics: \(chars) for accessory: \((accessory!.name)!)")
                setCharacteristics()
                lightView!.loadingIndicator!.stopAnimating()
            }
        }
    }
    
    // MARK: - Set Values in LightView
    
    func setCharacteristics() {
        setService(nil)
        setName(accessory?.name)
        setBrightness(brightnessValue)
        setPowerState(state)
        
    }
    
    func setService(name: String?) {
        if let name = serviceName {
//            lightView!.infotext!.text = name
        } else {
//            lightView!.infotext!.text = "Not Found"
        }
    }
    
    func setName(name: String?) {
        if let name = name {
            lightView!.infotext!.text = name
        } else {
            lightView!.infotext!.text = "Not Found"
        }
    }
    
    func setBrightness(value: Float?) {
        if let value = value {
            lightView!.slider!.value = value
            lightView!.slider!.hidden = false
        } else {
            lightView!.slider!.value = 0
            lightView!.slider!.hidden = true
        }
    }
    
    func setPowerState(state: Bool?) {
        if let state = state {
            lightView!.stateSwitch!.enabled = true
            lightView!.stateSwitch!.setOn(state, animated: false)
        } else {
            lightView!.stateSwitch!.enabled = false
        }
    }
    
    // MARK: - AccViewDelegate

    func accViewSliderChanged(value: Float) {
        print("SliderChanged: \(Int(value))")
//        accessory?.setCharacteristic([CharacteristicKey.brightness : value])
    }
    
    func accViewSwitchTapped(state: Bool) {
        print("SwitchChanged: \(state)")
//        accessory?.setCharacteristic([CharacteristicKey.powerState : state])
    }
    
    func accViewButtonTapped(state: String) {
    }

}
