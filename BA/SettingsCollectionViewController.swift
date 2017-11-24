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

        settings = ["Über die App", "Info-Galerie", "FAQs", "Einstellungen", "Impressum"]
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SettingsCollectionViewCell

        cell.label!.text = settings[indexPath.row]

        cell.label!.textColor = UIColor.Custom.blue
        cell.layer.borderColor = UIColor.Custom.blue.cgColor

        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8

        return cell
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "App", sender: self)
        case 1:
            performSegue(withIdentifier: "Galerie", sender: self)
        case 2:
            performSegue(withIdentifier: "FAQ", sender: self)
        case 3:
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
            }
        case 4:
            performSegue(withIdentifier: "Impressum", sender: self)
        default: break
        }
    }

    // MARK: - Prepare for Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Impressum" {
            let _ = segue.destination as! ImprintViewController
        } else if segue.identifier == "App" {
            let _ = segue.destination
        } else if segue.identifier == "FAQ" {
            let _ = segue.destination as! FAQViewController
        } else if segue.identifier == "Galerie" {
            let _ = segue.destination as! GalleryViewController
        }
    }

}
