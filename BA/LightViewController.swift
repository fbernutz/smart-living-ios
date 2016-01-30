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
    
    var size : CGFloat?
    
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
        
        size = lightView!.cView!.frame.size.height
    }
    
    // MARK: - Set Values in LightView
    
    func setCharacteristics() {
        setService(nil)
        setName(accessory?.name)
        setPowerState(state)
        
        if state == true {
            setBrightness(brightnessValue)
        } else {
            setBrightness(0)
        }
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
            lightView?.infotext?.hidden = false
            lightView?.infotext?.text = name
        } else {
            lightView?.infotext?.hidden = false
        }
    }
    
    func setBrightness(value: Float?) {
        if let value = value {
            lightView!.slider!.value = value
            lightView!.slider!.hidden = false
            lightView!.brightness!.text = "Helligkeit: \(Int(value))%"
            lightView!.brightness!.hidden = false
        } else {
            lightView!.slider!.hidden = true
            lightView!.brightness!.hidden = true
        }
    }
    
    func setPowerState(state: Bool?) {
        if let state = state {
            lightView!.stateSwitch!.hidden = false
            lightView!.stateSwitch!.setOn(state, animated: false)
            
        } else {
            lightView!.stateSwitch!.hidden = true
        }
    }
    
    // MARK: - AccViewDelegate

    func accViewSliderChanged(value: Float) {
        lightView!.brightness!.text = "Helligkeit: \(Int(value))%"
        contextHandler!.homeKitController!.setNewValues(accessory!, characteristic: [.brightness:value])
    }
    
    func accViewSwitchTapped(state: Bool) {
        if state == true {
            setBrightness(brightnessValue)
        } else {
            setBrightness(0)
        }
        contextHandler!.homeKitController!.setNewValues(accessory!, characteristic: [.powerState:state])
    }
    
    func accViewButtonTapped(state: String) {
    }

}
