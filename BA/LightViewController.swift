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
            setName(accessory!.name)
        }
    }
    
    var characteristics : [String:AnyObject]? {
        didSet {
            if let chars = characteristics {
                print(chars)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightView!.delegate = self
        
        accessory!.getCharacteristics()
        characteristics = accessory?.characteristics
        
        setCharacteristics()
    }
    
    // MARK: - Set Values in LightView
    
    func setCharacteristics() {
        setName(accessory?.name)
        setState(true)
        setSlider(20)
    }
    
    func setName(name: String?) {
        lightView?.infotext?.text = name ?? "Test"
    }
    
    func setState(state: Bool) {
        lightView?.stateSwitch?.setOn(state, animated: false)
    }
    
    func setSlider(value: Float) {
        lightView?.slider?.value = value
    }
    
    // MARK: - LightViewDelegate

    func lightViewSliderChanged(value: Float) {
        print("SliderChanged: \(Int(value))")
    }
    
    func lightViewSwitchTapped(state: Bool) {
        print("SwitchChanged: \(state)")
    }
    

}
