//
//  AccViewDelegate.swift
//  BA
//
//  Created by Felizia Bernutz on 31.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import Foundation

protocol AccViewDelegate {

    func accViewSliderChanged(_ value: Float)
    func accViewSwitchTapped(_ state: Bool)
    func accViewButtonTapped(_ state: String)

}
