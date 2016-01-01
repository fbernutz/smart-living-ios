//
//  LightViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 10.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class LightViewController: UIViewController, LightViewDelegate {
    
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
                print(chars)
                if !chars.isEmpty {
                    serviceName = chars.filter{ $0.0 == CharacteristicKey.serviceName }.first.map{ $0.1 as! String }
                    brightness = chars.filter{ $0.0 == CharacteristicKey.brightness }.first.map{ $0.1 as! Float }
                    state = chars.filter{ $0.0 == CharacteristicKey.powerState }.first.map{ $0.1 as! Bool }
                }
            }
        }
    }
    
    var serviceName : String?
    var brightness : Float?
    var state : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightView!.delegate = self
        
        if let chars = characteristics {
            if !chars.isEmpty {
                setCharacteristics()
            }
        }
    }
    
    // MARK: - Set Values in LightView
    
    func setCharacteristics() {
        setName(accessory?.name)
        setState(state!)
        setSlider(brightness!)
    }
    
    func setName(name: String?) {
        lightView!.infotext!.text = name ?? "Test"
    }
    
    func setState(state: Bool) {
        lightView!.stateSwitch!.setOn(state, animated: false)
    }
    
    func setSlider(value: Float) {
        lightView!.slider!.value = value
    }
    
    // MARK: - LightViewDelegate

    func lightViewSliderChanged(value: Float) {
        print("SliderChanged: \(Int(value))")
    }
    
    func lightViewSwitchTapped(state: Bool) {
        print("SwitchChanged: \(state)")
    }
    

}
