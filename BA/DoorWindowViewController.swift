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

    var contextHandler: ContextHandler?

    var dict: NSMutableDictionary?

    var accessory: AccessoryItem? {
        didSet {
            if accessory?.characteristics != nil {
                characteristics = accessory!.characteristics
            }

            reachable = accessory?.reachable
        }
    }

    var characteristics: [CharacteristicKey:AnyObject]? {
        didSet {
            if let chars = characteristics {
                if !chars.isEmpty {
                    serviceName = chars.filter { $0.0 == CharacteristicKey.serviceName }.first.map { $0.1 as! String }
                    state = chars.filter { $0.0 == CharacteristicKey.doorState }.first.map { $0.1 as! Bool }
                    //TODO: last edited time
                    //time = NSDate()
                }
            }
        }
    }

    var reachable: Bool?

    var serviceName: String? {
        didSet {
            if let _ = doorWindowView {
                setName(serviceName)
            }
        }
    }

    var oldState: Bool?

    var state: Bool? {
        didSet {
            if let _ = doorWindowView {
                setDoorState(state)
            }
        }
    }

    var doorCounter: Int? {
        didSet {
            if doorCounter != nil {
                if let state = state, let old = oldState {
                    if state != old {
                        doorCounter = doorCounter! + 1
                        setDoorCounter(doorCounter)
                        setDict(doorCounter!, state: state, dict: dict!)
                    }
                }
            }
        }
    }

    var time: Date? {
        didSet {
            if let _ = doorWindowView {
                setLastTime(time)
            }
        }
    }

    var size: CGFloat?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if dict == nil {
            dict = getDict()
        }

        oldState = getOldValue(dict!)
        doorCounter = getCounter(dict!)

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

        size = doorWindowView!.cView!.frame.size.height
    }

    // MARK: - Read and write door counter plist

    func getDict() -> NSMutableDictionary {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("AccessoryChars.plist")

        let fileManager = FileManager.default

        // Check if file exists
        if(!fileManager.fileExists(atPath: path)) {
            // If it doesn't, copy it from the default file in the Resources folder
            if let bundlePath = Bundle.main.path(forResource: "AccessoryChars", ofType: "plist") {
//                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
//                print("Bundle Accessories.plist file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
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

    func getCounter(_ dict: NSMutableDictionary) -> Int {
        let counter = dict.object(forKey: "doorCounter") as! Int
        return counter
    }

    func getOldValue(_ dict: NSMutableDictionary) -> Bool {
        let oldValue = dict.object(forKey: "oldState") as! Bool
        return oldValue
    }

    func setDict(_ counter: Int, state: Bool, dict: NSMutableDictionary) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("AccessoryChars.plist")

        dict["oldState"] = state
        dict["doorCounter"] = counter
        dict.write(toFile: path, atomically: true)
    }

    // MARK: - Set Values in LightView

    func setCharacteristics() {
        setService(nil)
        setName(accessory?.name)
        setDoorState(state)
//        setLastTime(time)
        setDoorCounter(doorCounter)
    }

    func setService(_ name: String?) {
        if let _ = serviceName {
            //            lightView!.infotext!.text = name
        } else {
            //            lightView!.infotext!.text = "Not Found"
        }
    }

    func setName(_ name: String?) {
        if let name = name {
            doorWindowView?.infotext?.isHidden = false
            doorWindowView?.infotext?.text = name
        } else {
            doorWindowView?.infotext?.isHidden = true
        }
    }

    func setDoorState(_ state: Bool?) {
        if let state = state {
            doorWindowView?.doorStateBtn?.isHidden = false
            if !state {
                doorWindowView?.doorStateBtn?.setTitle("Offen", for: UIControlState())
            } else {
                doorWindowView?.doorStateBtn?.setTitle("Zu", for: UIControlState())
            }
        } else {
            doorWindowView?.doorStateBtn?.isHidden = true
        }
    }

    func setLastTime(_ time: Date?) {
        if let time = time {
            doorWindowView?.stateChangedTime?.isHidden = false
            doorWindowView?.stateChangedTime?.text = "\(time)"
        } else {
            doorWindowView?.stateChangedTime?.isHidden = true
        }
    }

    func setDoorCounter(_ counter: Int?) {
        if let counter = counter {
            doorWindowView?.stateChangedTime?.isHidden = false
            doorWindowView?.stateChangedTime?.text = "\(counter)x"
        } else {
            doorWindowView?.stateChangedTime?.isHidden = true
        }
    }

}
