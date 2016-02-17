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
    
    var localHomes: [Home]?
    var localRooms: [Room]?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func changeRoom(sender: UIButton) {
        let sheet = self.createActionSheet()
        parentTableView!.presentViewController(sheet, animated: true, completion: nil)
    }
    
    func createActionSheet() -> UIAlertController {
        let sheet = UIAlertController(title: "Zuhause | Raum", message: "Wähle einen anderen Raum aus, um dessen zugehörige Geräte zu steuern.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for home in localHomes! {
            let roomsInHome = localRooms!.filter{ $0.homeID == home.id }.map{ room in
                sheet.addAction(UIAlertAction(title: "\(home.name!) | \(room.name!)", style: UIAlertActionStyle.Default)
                    { action in
                        if !self.parentTableView!.refreshControl!.refreshing {
                            self.parentTableView!.refreshControl!.beginRefreshing()
                            self.parentTableView!.tableView.reloadData()
                        }
                        self.parentTableView!.contextHandler?.homeID = home.id
                        self.parentTableView!.contextHandler?.roomID = room.id
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
