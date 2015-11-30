//
//  ViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 02.10.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit
import HomeKit

class OverviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var contextHandler: ContextHandler?
    var homes : [String]?
    var activeHome : String?
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBAction func addHome(sender: UIButton) {
        let alert = UIAlertController(title: "Add Home", message: "Add a new home to your Home List", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler:
            { (alertAction: UIAlertAction!) -> Void in
                
                let homeTextField = alert.textFields?[0]
                self.contextHandler?.homeKitController!.addHome(homeTextField!.text!)
                
        })
        )
        self.presentViewController(alert, animated: true, completion: nil)
        
        self.tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInformation()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.reloadData()
    }
    
    func loadInformation() {
        
        if contextHandler == nil {
            contextHandler = appDelegate.contextHandler
        }
        
//        homes = contextHandler?.homeKitHomeNames
    }
    
    // MARK: - TableView Delegates
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath)
        
        let currentHome = homes?[indexPath.row]
        
        cell.textLabel?.text = currentHome
        cell.detailTextLabel?.text = "Room unknown"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homes?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        activeHome = homes![indexPath.row]
        performSegueWithIdentifier("detailViewSegue", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if editingStyle == .Delete{
                
//                let home = self.contextHandler?.homeKitHomes?[indexPath.row]
//                self.contextHandler?.homeKitController!.removeHome(home!)
                homes?.removeAtIndex(indexPath.row)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                tableView.reloadData()
            }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailViewSegue" {
            let vc = segue.destinationViewController as! DetailViewController
            vc.home = activeHome
            vc.room = "Room1"
        }
    }
    
}

