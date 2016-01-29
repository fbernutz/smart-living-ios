//
//  WeatherView.swift
//  BA
//
//  Created by Felizia Bernutz on 17.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class WeatherView: AccView {
    
    @IBOutlet weak var cView: UIView?
    @IBOutlet weak var humidity: UILabel?
    @IBOutlet weak var pressure: UILabel?
    @IBOutlet weak var temperature: UILabel?
    @IBOutlet weak var name: UILabel?
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    
}
