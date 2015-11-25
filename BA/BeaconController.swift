//
//  BeaconController.swift
//  BA
//
//  Created by Felizia Bernutz on 29.10.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconController: NSObject, CLLocationManagerDelegate {
    
    // creating region with uuid (and or major, minor) and one identifier
    let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Beacon")
    
    // locationManager = CLLocationManager()
    // locationManager.delegate = self
    
    // 1 check AuthorizationStatus
    // 2 CLLocationManager.isMonitoringAvailableForClass
    // 3 Start Monitoring
    // 4 Start Ranging
    
    
    // MARK: DELEGATES
//    
//    // TODO: didStartMonitoringForRegion -> locationManager.requestStateForRegion
//    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
//        <#code#>
//    }
//    // didChangeAuthorizationStatus
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        <#code#>
//    }
//    
//    // TODO: didRangeBeacons -> most important one 
//    // -> nur wenn Beacon sich geändert hat seit dem letzten erkannten 
//    // -> delegate mit Nachricht, welches Beacon gefunden wurde: 
//    // delegate?.beaconFound(self, major: closestBeacon.major.integerValue, minor: closestBeacon.minor.integerValue)
//    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
//        <#code#>
//    }
//    
//    // TODO: didDetermineState -> Inside/Outside -> start/stop ranging
//    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
//        <#code#>
//    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Error monitoring for region")
    }
    
    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        print("Error ranging beacon for region")
    }
}

