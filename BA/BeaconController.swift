//
//  BeaconController.swift
//  BA
//
//  Created by Felizia Bernutz on 23.01.16.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconController: NSObject, CLLocationManagerDelegate {
    
    let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimote")
    
    let locationManager = CLLocationManager()
    var monitoringStarted: Bool = false
    var delegate: BeaconControllerDelegate?
    var lastBeacon: CLBeacon?
    
    var major: Int?
    var minor: Int?
    
    
    // MARK: - Start beacon action
    
    func checkAuthorization() {
        
        locationManager.delegate = self
        
        // 1 check AuthorizationStatus
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            monitoringStarted = true
            checkMonitoringAvailability()
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
        case .Restricted, .Denied:
            return
        }
    }
    
    func checkMonitoringAvailability () {
        
        // 2 check if monitoring is available
        if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion){
            startMonitoringInRegion(beaconRegion)
        } else {
            monitoringStarted = false
        }
    }
    
    func startMonitoringInRegion (region: CLBeaconRegion) {
        
        // 3 Start monitoring for region
        locationManager.startMonitoringForRegion(region)
        
        // 4 Start ranging beacons in region
        locationManager.startRangingBeaconsInRegion(region)
        
        monitoringStarted = true
    }
    
    // MARK: - Location Manager Delegates
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        locationManager.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined, .AuthorizedAlways, .AuthorizedWhenInUse:
            if monitoringStarted == false {
                checkMonitoringAvailability()
            }
        default: break
        }
    }

    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        //1 filter ranged beacons
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        if !knownBeacons.isEmpty {
            //2 set closest beacon
            let closestBeacon = knownBeacons[0]
            
            //3 check if last beacon is closest beacon
            if closestBeacon.major != lastBeacon?.major && closestBeacon.minor != lastBeacon?.minor {
                
                //4 delegate with information which beacon was found
                delegate?.beaconFound(self, major: closestBeacon.major.integerValue, minor: closestBeacon.minor.integerValue)
                
                //5 set closestBeacon as last found beacon
                lastBeacon = closestBeacon
            }
        }
    }

    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        switch state {
        case .Inside:
            locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        case .Outside, .Unknown:
            locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Error monitoring for region: \(error)")
    }
    
    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        print("Error ranging beacon for region: \(error)")
    }
    
    
}

