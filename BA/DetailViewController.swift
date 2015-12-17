//
//  DetailViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 20.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, HomeKitControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var contextHandler : ContextHandler?
    var accessoryStoryboard : UIStoryboard?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    @IBOutlet weak var homeName: UILabel?
    @IBOutlet weak var roomName: UILabel?
    @IBOutlet weak var accessoryName: UILabel?
    @IBOutlet weak var accessoriesTableView: UITableView?
    
    @IBAction func addAccessory(sender: UIButton) {
        contextHandler?.loadAccessoryBrowser()
        performSegueWithIdentifier("showAllAccessoriesSegue", sender: self)
    }
    
    @IBAction func changeHome(sender: UIButton) {
        //choose another home or room
    }
    
    var viewControllerArray : [UIViewController]? {
        didSet {
            print("ViewControllerArray didSet with: \(viewControllerArray)")
            accessoriesTableView?.reloadData()
        }
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
    
    var accessoryList : [String] = []
    
    var accessories : [IAccessory]? {
        didSet {
            accessoriesTableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contextHandler == nil {
            contextHandler = appDelegate.contextHandler
        }
        
        let controller = contextHandler!.homeKitController
        controller!.delegate = self
        
        accessoryStoryboard = UIStoryboard(name: "Accessories", bundle: nil)
    }
   
    
    // MARK: - HomeKitController Delegates
    
    func hasLoadedData(status: Bool) {
        if status == true {
            print("loading successful")
            
            home = contextHandler!.retrieveHome()
            room = contextHandler!.retrieveRoom()
            accessories = contextHandler!.retrieveAccessories()
            
            viewControllerArray = contextHandler!.retrieveViewControllerList()
        } else {
            print("loading failed")
        }
    }
    
    // MARK: - TableView Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewController = viewControllerArray {
            return viewController.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let vcInRow = viewControllerArray![indexPath.row]
        let view = vcInRow.view
        let size = view?.frame.height
        return size!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let vcInRow = viewControllerArray![indexPath.row]
        let view = vcInRow.view
        let cell = tableView.dequeueReusableCellWithIdentifier("accessoryCell")!
        
        view.frame = cell.frame
        cell.contentView.addSubview(view)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected row \(indexPath.row)")
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAllAccessoriesSegue" {
            let vc = segue.destinationViewController as! DiscoveryViewController
            vc.contextHandler = contextHandler
        }
    }
}
