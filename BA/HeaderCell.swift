//
//  headerCell.swift
//  BA
//
//  Created by Felizia Bernutz on 28.01.16.
//  Copyright © 2016 Felizia Bernutz. All rights reserved.
//

import UIKit

class headerCell: UITableViewCell {

    @IBOutlet weak var homeName: UILabel?
    @IBOutlet weak var roomName: UILabel?
    
    @IBOutlet weak var beaconButton: UIButton?
    @IBOutlet weak var changeRoomButton: UIButton?
    
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
    
    var home: String?
    var room: String?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        beaconButton!.addTarget(self, action: "addBeacon:", forControlEvents: .TouchUpInside)
        changeRoomButton!.addTarget(self, action: "changeRoom:", forControlEvents: .TouchUpInside)
    }
    
    // MARK: - Change Room
    
    @IBAction func changeRoom(sender: UIButton) {
        let sheet = self.createActionSheet()
        parentTableView!.presentViewController(sheet, animated: true, completion: nil)
        
        parentTableView!.spinner?.startAnimating()
    }
    
    func createActionSheet() -> UIAlertController {
        let sheet = UIAlertController(title: "home > room", message: "Wähle einen anderen Raum aus, um dessen Accessories zu steuern.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for home in parentTableView!.localHomes! {
            let roomsInHome = parentTableView!.localRooms!.filter{ $0.homeID == home.id }.map{ room in
                sheet.addAction(UIAlertAction(title: "\(home.name!) > \(room.name!)", style: UIAlertActionStyle.Default)
                    { action in
                        self.parentTableView!.controller!.currentHomeID = home.id
                        self.parentTableView!.controller!.currentRoomID = room.id
                        
                        self.parentTableView!.spinner?.stopAnimating()
                    }
                )
            }
        }
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action in
            self.parentTableView!.spinner?.stopAnimating()
            })
        
        return sheet
    }
    
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
