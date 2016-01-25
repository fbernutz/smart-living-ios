//
//  SettingsCollectionViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 25.01.16.
//  Copyright © 2016 Felizia Bernutz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SettingsCell"

class SettingsCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var settings = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Weiteres"
        
        settings = ["Impressum", "FAQ", "Info"]
    }

    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SettingsCollectionViewCell
    
        cell.label!.text = settings[indexPath.row]
        
        cell.label!.textColor = Colours.blue()
        cell.layer.borderColor = Colours.blue().CGColor
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("Impressum", sender: self)
        case 1:
            performSegueWithIdentifier("FAQ", sender: self)
        case 2:
            performSegueWithIdentifier("Galerie", sender: self)
        default: break
        }
    }
    
    //MARK: - Prepare for Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Impressum" {
            let _ = segue.destinationViewController as! ImprintViewController
        } else if segue.identifier == "FAQ" {
            let _ = segue.destinationViewController as! FAQViewController
        } else if segue.identifier == "Galerie" {
            let _ = segue.destinationViewController as! GalleryViewController
        }
    }
    
}
