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
    
    var dict: NSMutableDictionary?
    
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
                    //TODO: last edited time
                    //time = NSDate()
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
    
    var oldState : Bool?
    
    var state : Bool? {
        didSet {
            if let _ = doorWindowView {
                setDoorState(state)
            }
        }
    }
    
    var doorCounter : Int? {
        didSet {
            if var counter = doorCounter, let state = state, let old = oldState {
                if state != old {
                    counter++
                    setDoorCounter(counter)
                    setDict(counter, state: state, dict: dict!)
                }
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
        
        if dict == nil {
            dict = getDict()
        }
        
        oldState = getOldValue(dict!)
        doorCounter = getCounter(dict!)
        
        if let chars = characteristics {
            if !chars.isEmpty {
                print(">>>setCharacteristics: \(chars) for accessory: \((accessory!.name)!)")
                setCharacteristics()
                doorWindowView!.loadingIndicator!.stopAnimating()
            }
        }
    }
    
    // MARK: - Read and write plist
    
    func getDict() -> NSMutableDictionary {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("AccessoryChars.plist")
        
        let fileManager = NSFileManager.defaultManager()
        
        // Check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Resources folder
            if let bundlePath = NSBundle.mainBundle().pathForResource("AccessoryChars", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle Accessories.plist file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                } catch _ {
                }
                print("copy")
            }
        }
        
        if let dict = NSMutableDictionary(contentsOfFile: path) {
            return dict
        }
        
        return NSMutableDictionary(contentsOfFile: path)!
    }
    
    func getCounter(dict: NSMutableDictionary) -> Int {
        let counter = dict.objectForKey("doorCounter") as! Int
        return counter
    }
    
    func getOldValue(dict: NSMutableDictionary) -> Bool {
        let oldValue = dict.objectForKey("oldState") as! Bool
        return oldValue
    }
    
    func setDict(counter: Int, state: Bool, dict: NSMutableDictionary) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("AccessoryChars.plist")
        
        dict["oldState"] = state
        dict["doorCounter"] = counter
        dict.writeToFile(path, atomically: true)
    }
    
    // MARK: - Set Values in LightView
    
    func setCharacteristics() {
        setService(nil)
        setName(accessory?.name)
        setDoorState(state)
//        setLastTime(time)
        setDoorCounter(doorCounter)
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
    
    func setDoorCounter(counter: Int?) {
        if let counter = counter {
            doorWindowView!.stateChangedTime?.text = "\(counter)"
        } else {
            doorWindowView!.stateChangedTime?.text = "Not found"
        }
    }
    
}
