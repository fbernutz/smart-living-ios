//
//  DetailViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, HomeKitControllerDelegate, ContextHandlerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var contextHandler : ContextHandler?
    
    @IBOutlet weak var homeName: UILabel?
    @IBOutlet weak var roomName: UILabel?
    @IBOutlet weak var accessoriesTableView: UITableView?
    
    @IBAction func addAccessory(sender: UIButton) {
        performSegueWithIdentifier("showAllAccessoriesSegue", sender: self)
    }
    
    @IBAction func changeHome(sender: UIButton) {
        //choose another home or room
    }
    
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
    
    var viewControllerArray : [UIViewController] = [] {
        didSet {
            accessoriesTableView?.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contextHandler == nil {
            contextHandler = appDelegate.contextHandler
        }
        
        contextHandler!.delegate = self
        
        let controller = contextHandler!.homeKitController
        controller!.delegate = self
    }
    
    
    // MARK: - HomeKitController Delegates
    
    func hasLoadedData(status: Bool) {
        if status == true {
            print("loading successful")
            
            home = contextHandler!.retrieveHome()
            room = contextHandler!.retrieveRoom()
            viewControllerArray = contextHandler!.retrieveViewControllerList()!
            
        } else {
            print("loading failed")
        }
    }
    
    func hasCreatedDefaultHomes(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - ContextHandler Delegates
    
    func contextHandlerChangedVCArray() {
        viewControllerArray = contextHandler!.retrieveViewControllerList()!
    }
    
    // MARK: - TableView Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewControllerArray.count != 0 {
            return viewControllerArray.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if viewControllerArray.count != 0 {
            let vcInRow = viewControllerArray[indexPath.row]
            let view = vcInRow.view
            let size = view?.frame.height
            return size!
        }
        
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if viewControllerArray.count != 0 {
            let vcInRow = viewControllerArray[indexPath.row]
            let view = vcInRow.view
            let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell")!
            
            view.frame = cell.frame
            cell.contentView.addSubview(view)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell")!
            cell.textLabel!.text = "No accessories connected"
            return cell
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAllAccessoriesSegue" {
            let vc = segue.destinationViewController as! DiscoveryViewController
            vc.contextHandler = contextHandler
        }
    }
}
