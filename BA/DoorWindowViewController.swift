//
//  DoorWindowViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 17.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DoorWindowViewController: UIViewController {

    @IBOutlet var doorWindowView: DoorWindowView?
 
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
                    state = chars.filter{ $0.0 == CharacteristicKey.doorState }.first.map{ $0.1 as! Bool }
                    time = NSDate() //TODO: last edited time
                }
            }
        }
    }
    
    var serviceName : String? {
        didSet {
            if let _ = doorWindowView {
                setName(serviceName)
            }
        }
    }
    
    var state : Bool? {
        didSet {
            if let _ = doorWindowView {
                setDoorState(state)
            }
        }
    }
    
    var time : NSDate? {
        didSet {
            if let _ = doorWindowView {
                setLastTime(time)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doorWindowView!.loadingIndicator!.startAnimating()
        
        if let chars = characteristics {
            if !chars.isEmpty {
                print(">>>setCharacteristics: \(chars) for accessory: \((accessory!.name)!)")
                setCharacteristics()
                doorWindowView!.loadingIndicator!.stopAnimating()
            }
        }
    }
    
    // MARK: - Set Values in LightView
    
    func setCharacteristics() {
        setService(nil)
        setName(accessory?.name)
        setDoorState(state)
        setLastTime(time)
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
            doorWindowView!.infotext!.text = name
        } else {
            doorWindowView!.infotext!.text = "Not Found"
        }
    }
    
    func setDoorState(state: Bool?) {
        if let state = state {
            doorWindowView!.doorStateBtn!.enabled = true
            if !state {
                doorWindowView!.doorStateBtn!.setTitle("Offen", forState: .Normal)
            } else {
                doorWindowView!.doorStateBtn!.setTitle("Zu", forState: .Normal)
            }
        } else {
            doorWindowView!.doorStateBtn!.enabled = false
            doorWindowView!.doorStateBtn!.setTitle("No", forState: .Normal)
        }
    }
    
    func setLastTime(time: NSDate?) {
        if let time = time {
            doorWindowView!.stateChangedTime?.text = "\(time)"
        } else {
            doorWindowView!.stateChangedTime?.text = "Not found"
        }
    }

}
