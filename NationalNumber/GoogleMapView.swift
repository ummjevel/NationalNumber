//
//  GoogleMapView.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/05.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    
    typealias UIViewType = GMSMapView
    
    private static let defaultCamera = GMSCameraPosition.camera(withLatitude: 38.1206, longitude: 128.4654, zoom: 10.0)
    // (withLatitude: -33.86, longitude: 151.20, zoom: 6.0) // 38.12067304510615, 128.46542415288081
    // (withLatitude: 37.5484, longitude: 127.0534, zoom: 10.0)
    private let mapView : GMSMapView
    private weak var mapDelegate: GMSMapViewDelegateWrapper?
    let marker : GMSMarker = GMSMarker()

    init() {
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GoogleMapView.defaultCamera)
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        self.mapView = mapView
        let mapDelegateWrapper = GMSMapViewDelegateWrapper()
        self.mapDelegate = mapDelegateWrapper
        self.mapView.delegate = mapDelegateWrapper
   }
    
    func makeUIView(context: Context) -> GMSMapView {
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        marker.position = CLLocationCoordinate2D(latitude: 38.1206, longitude: 128.4654)
        // (latitude: -33.86, longitude: 151.20)
        marker.title = "설악산 대청봉"
        marker.snippet = "전민정 다리 부서진 곳"
        marker.map = mapView
    }
    
    func update(cameraPosition: GMSCameraPosition) -> some View {
        mapView.animate(to: cameraPosition)
        return self
    }
    
    func update(zoom level: Float) -> some View {
        mapView.animate(toZoom: level)
        return self
    }
    
}
struct GoogleMapView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleMapView()
    }
}
