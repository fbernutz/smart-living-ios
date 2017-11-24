//
//  AccessoryViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 22.05.15.
//  Copyright (c) 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class DiscoveryViewController: UITableViewController, HomeKitControllerNewAccessoriesDelegate {
    
    var contextHandler: ContextHandler?
    var controller : HomeKitController?
    
    let searchingTitle = "Auf der Suche..."
    let discoveredTitle = "Tada!"
    
    var isAddingAccessory : Bool = false
    
    var accessoryList : [String]? = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = contextHandler!.homeKitController
        controller!.accessoryDelegate = self
        
        title = searchingTitle
        accessoryList = controller!.discoveredAccessories()
        
        self.refreshControl!.addTarget(self, action: #selector(DiscoveryViewController.refresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        controller?.startSearchingForAccessories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !isAddingAccessory {
            controller?.stopSearching()
        }
    }
    
    // MARK: - Table Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if accessoryList != nil {
            return accessoryList!.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newAccessoryCell")
        cell?.textLabel?.text = accessoryList![indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let accessory = accessoryList![indexPath.row]
        
        isAddingAccessory = true
        
        self.contextHandler!.addNewAccessory(accessory, completionHandler: { success, error in
            if success {
                self.isAddingAccessory = false
                self.accessoryList?.remove(at: (self.accessoryList?.index(of: accessory)!)!)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.isAddingAccessory = false
                tableView.deselectRow(at: indexPath, animated: true)
            }
        })
    }
    
    @objc func refresh(_ sender: AnyObject) {
        if title == discoveredTitle {
            controller!.startSearchingForAccessories()
            title = searchingTitle
            if self.refreshControl!.isRefreshing {
                self.refreshControl!.endRefreshing()
            }
            tableView?.reloadData()
        } else {
            if self.refreshControl!.isRefreshing {
                self.refreshControl!.endRefreshing()
            }
        }
    }
    
    // MARK: - HomeKitController Delegates
    
    func hasLoadedNewAccessory(_ name: String, stillLoading: Bool) {
        if stillLoading {
            if !accessoryList!.contains(name) {
                accessoryList!.append(name)
            }
            title = searchingTitle
        } else {
            title = discoveredTitle
        }
    }
    
}

