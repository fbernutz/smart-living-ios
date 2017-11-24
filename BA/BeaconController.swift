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
    
    let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimote")
    
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
        case .authorizedAlways, .authorizedWhenInUse:
            monitoringStarted = true
            checkMonitoringAvailability()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            return
        }
    }
    
    func checkMonitoringAvailability () {
        
        // 2 check if monitoring is available
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.classForCoder()){
            startMonitoringInRegion(beaconRegion)
        } else {
            monitoringStarted = false
        }
    }
    
    func startMonitoringInRegion (_ region: CLBeaconRegion) {
        
        // 3 Start monitoring for region
        locationManager.startMonitoring(for: region)
        
        // 4 Start ranging beacons in region
        locationManager.startRangingBeacons(in: region)
        
        monitoringStarted = true
    }
    
    // MARK: - Location Manager Delegates
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
            if monitoringStarted == false {
                checkMonitoringAvailability()
            }
        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        //1 filter ranged beacons
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        
        if !knownBeacons.isEmpty {
            //2 set closest beacon
            let closestBeacon = knownBeacons[0]
            
            //3 check if last beacon is closest beacon
            if closestBeacon.major != lastBeacon?.major && closestBeacon.minor != lastBeacon?.minor {
                
                //4 delegate with information which beacon was found
                delegate?.beaconFound(self, major: closestBeacon.major.intValue, minor: closestBeacon.minor.intValue)
                
                //5 set closestBeacon as last found beacon
                lastBeacon = closestBeacon
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
            locationManager.startRangingBeacons(in: region as! CLBeaconRegion)
        case .outside, .unknown:
            locationManager.stopRangingBeacons(in: region as! CLBeaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Error monitoring for region: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print("Error ranging beacon for region: \(error)")
    }
    
    
}

