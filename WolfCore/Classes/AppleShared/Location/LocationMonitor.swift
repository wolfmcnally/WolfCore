//
//  LocationMonitor.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import CoreLocation
import Foundation

#if canImport(UIKit)
    import UIKit
#endif

public class LocationMonitor {
    private let locationManager: LocationManager
    public private(set) var recentLocations = [CLLocation]()
    private var isStarted: Bool = false

    public var onLocationUpdated: ((LocationMonitor) -> Void)?

    public var location: CLLocation? {
        return locationManager.location
    }

    public init(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyKilometer, distanceFilter: CLLocationDistance = kCLDistanceFilterNone) {
        locationManager = LocationManager()
        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.distanceFilter = distanceFilter
    }

    #if os(macOS)
    public func start() {
    guard !isStarted else { return }

    isStarted = true

    locationManager.didUpdateLocations = { [unowned self] locations in
    self.recentLocations = locations
    self.onLocationUpdated?(self)
    //logTrace(locations)
    }

    //    locationManager.didChangeAuthorizationStatus = { authorizationStatus in
    //      print("authorizationStatus: \(authorizationStatus)")
    //    }
    //
    //    locationManager.didFail = { error in
    //      print("didFail: \(error)")
    //    }

    locationManager.startUpdatingLocation()
    }
    #endif

    #if os(iOS)
    public func start(from viewController: UIViewController) {
    guard !isStarted else { return }

    isStarted = true

    guard DeviceAccess.checkLocationWhenInUseAuthorized(from: viewController) else {
    logWarning("Unable to start monitoring location.", group: .location)
    return
    }

    locationManager.didChangeAuthorizationStatus = { [unowned self] status in
    switch status {
    case .notDetermined:
    break
    case .authorizedAlways, .authorizedWhenInUse:
    self.locationManager.startUpdatingLocation()
    case .denied, .restricted:
    break
    }
    }

    locationManager.didUpdateLocations = { [unowned self] locations in
    self.recentLocations = locations
    self.onLocationUpdated?(self)
    //logTrace(locations)
    }

    locationManager.requestWhenInUseAuthorization()
    }
    #endif
}
