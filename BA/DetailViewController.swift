//
//  DetailViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, HomeKitControllerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var homeName: UILabel?
    @IBOutlet weak var roomName: UILabel?
    
    @IBAction func addAccessory(sender: UIButton) {
        
    }
    
    var contextHandler : ContextHandler?
    
    var home : String? {
        didSet {
            homeName?.text = home
        }
    }
    
    var room : String? {
        didSet {
            roomName?.text = room
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contextHandler == nil {
            contextHandler = appDelegate.contextHandler
        }
        
        let controller = contextHandler!.homeKitController
        controller!.delegate = self
    }
    
    
    func hasLoadedData(status: Bool) {
        if status == true {
            print("loading successful")
            
            home = contextHandler!.retrieveHome()
            room = contextHandler!.retrieveRoom()
            
        } else {
            print("loading failed")
        }
    }
    
    
}
