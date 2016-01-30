//
//  BeaconCell.swift
//  BA
//
//  Created by Felizia Bernutz on 30.01.16.
//  Copyright © 2016 Felizia Bernutz. All rights reserved.
//

import UIKit

class BeaconCell: UITableViewCell {

    @IBOutlet weak var majorLabel: UILabel?
    @IBOutlet weak var minorLabel: UILabel?
    
    var parentTableView : DetailViewController?
    
    var major: Int? {
        didSet {
            if let major = major {
                majorLabel?.text = "\(major)"
            }
        }
    }
    
    var minor: Int? {
        didSet {
            if let minor = minor {
                minorLabel?.text = "\(minor)"
            }
        }
    }
    
    // MARK: - Delete Beacon To Room
    
    @IBAction func deleteBeaconFromRoom(sender: UIButton) {
        //TODO: delete beacon from room
        
//        self.parentTableView!.beaconConnected = false
    }
    
    // MARK: - Add Beacon To Room
    
    func addBeacon() {
        let alert = UIAlertController(title: "Beacon hinzufügen", message: "Verbinde das näheste Beacon mit \(parentTableView!.room!).", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction (title: "Hinzufügen", style: .Default) { action in
            let beaconRoom = BeaconRoomConnector(major: self.major!, minor: self.minor!, home: self.parentTableView!.home!, room: self.parentTableView!.room!)
            
            self.parentTableView!.contextHandler!.saveData(beaconRoom)
            
            print("AccessoryVC: beacon \(self.major!), \(self.minor!) connected to \(self.parentTableView!.room!)")
            
            self.alertBeaconAdded()
            })
        
        parentTableView!.presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertBeaconAdded() {
        let alert = UIAlertController(title: "Beacon hinzugefügt", message: "Das Beacon \(parentTableView!.major!), \(parentTableView!.minor!) wurde erfolgreich zu \(parentTableView!.home!), \(parentTableView!.room!) hinzugefügt.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel)
            { action in
                self.parentTableView!.beaconConnected = true
            }
        )
        
        parentTableView!.presentViewController(alert, animated: true, completion: nil)
    }
    
}
