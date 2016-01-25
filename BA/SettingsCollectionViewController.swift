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
        
        settings = ["Impressum", "FAQ", "Galerie"]
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
            performSegueWithIdentifier(settings[indexPath.row], sender: self)
        case 1:
            performSegueWithIdentifier(settings[indexPath.row], sender: self)
        case 2:
            performSegueWithIdentifier(settings[indexPath.row], sender: self)
        default: break
        }
    }
    
    //MARK: - Prepare for Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == settings[0] {
            let _ = segue.destinationViewController as! ImprintViewController
        } else if segue.identifier == settings[1] {
            let _ = segue.destinationViewController as! FAQViewController
        } else if segue.identifier == settings[2] {
            let _ = segue.destinationViewController as! GalleryViewController
        }
    }
    
}
