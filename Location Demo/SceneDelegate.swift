//
//  SceneDelegate.swift
//  Location Demo
//
//  Created by Ameen Mustafa on 11/11/23.
//

import Foundation
import CoreLocation
import UIKit
import SwiftUI

class LocationListener: ObservableObject {
    @Published var isInZone = false
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var isInZone = LocationListener()
    let locationManager = CLLocationManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let contentView = ContentView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView:  contentView.environmentObject(isInZone))
            self.window = window
            window.makeKeyAndVisible()
        }
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization() // Make sure to add necessary info.plist entries
        
        let locationCoordinates = CLLocationCoordinate2D(latitude: 29.9792, longitude: 31.1342) // Pyramids of Giza
        startMonitorRegionAtLocation(center: locationCoordinates, identifier: "Pyramids of Giza")
    }
    
    func startMonitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String) {
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
           
            let maxDistance = locationManager.maximumRegionMonitoringDistance
            
            // Register the region.
            let region = CLCircularRegion(center: center,
                 radius: maxDistance, identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
       
            locationManager.startMonitoring(for: region)
        }
    }
}

extension SceneDelegate : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        isInZone.isInZone = true

        if UIApplication.shared.applicationState == .active {
            print("behold the pyramids in all their eternal majesty")
        } else {
            
          let body = "You arrived at " + region.identifier
          let notificationContent = UNMutableNotificationContent()
          notificationContent.body = body
          notificationContent.sound = .default
          notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
          let request = UNNotificationRequest(
            identifier: "location_change",
            content: notificationContent,
            trigger: trigger)
          UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
              print("Error: \(error)")
            }
          }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        isInZone.isInZone = false

        if UIApplication.shared.applicationState == .active {
            print("you have left the pyramids")
        } else {
            
            let body = "You left " + region.identifier
          let notificationContent = UNMutableNotificationContent()
          notificationContent.body = body
          notificationContent.sound = .default
          notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
          let request = UNNotificationRequest(
            identifier: "location_change",
            content: notificationContent,
            trigger: trigger)
          UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
              print("Error: \(error)")
            }
          }
        }
    }
}
