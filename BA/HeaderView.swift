//
//  HeaderView.swift
//  BA
//
//  Created by Felizia Bernutz on 29.01.16.
//  Copyright © 2016 Felizia Bernutz. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var homeName: UILabel?
    @IBOutlet weak var roomName: UILabel?
    
    @IBOutlet weak var changeRoomButton: UIButton?
    
    var parentTableView : DetailViewController?
    
    var home: String? {
        didSet {
            homeName?.text = home
        }
    }
    
    var room: String? {
        didSet {
            roomName?.text = room
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        homeName!.preferredMaxLayoutWidth = homeName!.bounds.width
//        roomName!.preferredMaxLayoutWidth = roomName!.bounds.width
    }
    
    @IBAction func changeRoom(sender: UIButton) {
        let sheet = self.createActionSheet()
        parentTableView!.presentViewController(sheet, animated: true, completion: nil)
    }
    
    func createActionSheet() -> UIAlertController {
        let sheet = UIAlertController(title: "Zuhause | Raum", message: "Wähle einen anderen Raum aus, um dessen zugehörige Geräte zu steuern.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for home in parentTableView!.localHomes! {
            let roomsInHome = parentTableView!.localRooms!.filter{ $0.homeID == home.id }.map{ room in
                sheet.addAction(UIAlertAction(title: "\(home.name!) | \(room.name!)", style: UIAlertActionStyle.Default)
                    { action in
                        if !self.parentTableView!.refreshControl!.refreshing {
                            self.parentTableView!.refreshControl!.beginRefreshing()
                            self.parentTableView!.tableView.reloadData()
                        }
                        self.parentTableView!.controller!.currentHomeID = home.id
                        self.parentTableView!.controller!.currentRoomID = room.id
                    }
                )
            }
        }
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action in
            if self.parentTableView!.refreshControl!.refreshing {
                self.parentTableView!.refreshControl!.endRefreshing()
                self.parentTableView!.tableView.reloadData()
            }
            }
        )
        
        return sheet
    }

}
