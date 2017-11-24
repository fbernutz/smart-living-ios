//
//  HomeKitControllerDelegate.swift
//  BA
//
//  Created by Felizia Bernutz on 30.11.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import Foundation

protocol HomeKitControllerDelegate {
    func hasCreatedDefaultHomes(_ title: String, message: String)
}

protocol HomeKitControllerNewAccessoriesDelegate {
    func hasLoadedNewAccessory(_ name: String, stillLoading: Bool)
}
