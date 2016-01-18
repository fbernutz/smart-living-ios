//
//  AccViewDelegate.swift
//  BA
//
//  Created by Felizia Bernutz on 31.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import Foundation

protocol AccViewDelegate {

    func accViewSliderChanged(value: Float)
    func accViewSwitchTapped(state: Bool)
    func accViewButtonTapped(state: String)
    
}