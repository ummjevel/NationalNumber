//
//  GMSMapViewDelegateWrapper.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/05.
//

import Foundation
import GoogleMaps

@objc
class GMSMapViewDelegateWrapper: NSObject, GMSMapViewDelegate {
        
    var shouldHandleTap: Bool = true
    
    deinit {
        
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return shouldHandleTap
    }
    
    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
        
    }
    
}
