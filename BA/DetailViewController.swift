//
//  DetailViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var roomName: UILabel!
    var home : String? {
        didSet {
            
        }
    }
    
    var room : String? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        homeName.text = home
    }
    
}
