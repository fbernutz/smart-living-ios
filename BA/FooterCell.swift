//
//  FooterCell.swift
//  BA
//
//  Created by Felizia Bernutz on 29.01.16.
//  Copyright © 2016 Felizia Bernutz. All rights reserved.
//

import UIKit

class FooterCell: UITableViewCell {
    
    @IBOutlet weak var beaconButton: UIButton?
    
    var parentTableView : DetailViewController?
    
    var major: Int? {
        didSet {
            parentTableView!.major = major
        }
    }
    
    var minor: Int? {
        didSet {
            parentTableView!.minor = minor
        }
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        
//        beaconButton!.addTarget(self, action: "addBeacon:", forControlEvents: .TouchUpInside)
//    }
    
    
    // MARK: - Add Beacon To Room
    
    @IBAction func addBeacon(sender: UIButton) {
        let alert = UIAlertController(title: "Beacon hinzufügen", message: "Verbinde das näheste Beacon mit \(parentTableView!.room!).", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction (title: "Hinzufügen", style: .Default) { action in
            
            self.minor = self.parentTableView!.contextHandler!.minorBeacon
            self.major = self.parentTableView!.contextHandler!.majorBeacon
            
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
                // TODO: Beacon Button ausblenden oder anzeigen, dass verbunden
            }
        )
        
        parentTableView!.presentViewController(alert, animated: true, completion: nil)
    }
}
