//
//  DetailViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var roomName: UILabel!
    
    @IBAction func addAccessory(sender: UIButton) {
        
    }
    
    var contextHandler : ContextHandler?
    
    var home : String? {
        didSet {
            if home == nil {
                homeName.text = "Home funkt noch nicht"
            } else {
                homeName.text = home
            }
        }
    }
    
    var room : String? {
        didSet {
            if room == nil {
                roomName.text = "Room funkt noch nicht"
            } else {
                roomName.text = room
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contextHandler == nil {
            contextHandler = appDelegate.contextHandler
        }
        
//        home = contextHandler!.localHomes?[0].name
//        home = contextHandler!.retrieveHome()
//        room = contextHandler!.retrieveRoom()
    }
}
