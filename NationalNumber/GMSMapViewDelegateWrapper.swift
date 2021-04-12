//
//  GMSMapViewDelegateWrapper.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/05.
//

import Foundation
import GoogleMaps

@objc
class GMSMapViewDelegateWrapper: NSObject, GMSMapViewDelegate, CLLocationManagerDelegate {
        
    var shouldHandleTap: Bool = true
    
    deinit {
        
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("did tap my location button")
        return shouldHandleTap
    }
    
    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
        print("didtapmylocation mapview")
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("change cameraposition")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("mapview didtap marker")
        return shouldHandleTap
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("mapview idleat")
    }
    
}
