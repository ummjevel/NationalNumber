//
//  GoogleMapView.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/05.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

struct GoogleMapView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    @Binding var view_height: CGFloat
    typealias UIViewType = GMSMapView
    
    private static let defaultCamera = GMSCameraPosition.camera(withLatitude: 38.1206, longitude: 128.4654, zoom: 10.0)
    // (withLatitude: -33.86, longitude: 151.20, zoom: 6.0) // 38.12067304510615, 128.46542415288081
    // (withLatitude: 37.5484, longitude: 127.0534, zoom: 10.0)
    private let mapView : GMSMapView
    // private weak var mapDelegate: GMSMapViewDelegateWrapper?
    let marker : GMSMarker = GMSMarker()

    init(view_height: Binding<CGFloat>) {
    // init(view_height: CGFloat) {
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GoogleMapView.defaultCamera)
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        self._view_height = view_height
        // mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self._view_height.wrappedValue/10 + 70, right: 0)
        self.mapView = mapView
        /*let mapDelegateWrapper = GMSMapViewDelegateWrapper()
        self.mapDelegate = mapDelegateWrapper
        self.mapView.delegate = mapDelegateWrapper*/
   }
    
    func makeUIView(context: Context) -> GMSMapView {
        
        self.mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        marker.position = CLLocationCoordinate2D(latitude: 38.1206, longitude: 128.4654)
        // (latitude: -33.86, longitude: 151.20)
        marker.title = "설악산 대청봉"
        marker.snippet = "전민정 다리 부서진 곳"
        marker.map = mapView
        
        print("current longitude1")
        print(uiView.camera.target.longitude)
        print("current latitude1")
        print(uiView.camera.target.latitude)
    }
    
    
    func update(cameraPosition: GMSCameraPosition) -> some View {
        mapView.animate(to: cameraPosition)
        print("current longitude2")
        print(cameraPosition.target.longitude)
        print("current latitude2")
        print(cameraPosition.target.latitude)
        return self
    }
    
    func update(zoom level: Float) -> some View {
        mapView.animate(toZoom: level)
        print("current longitude3")
        print(mapView.camera.target.longitude)
        print("current latitude3")
        print(mapView.camera.target.latitude)
        return self
    }
    
    
    class Coordinator : NSObject, GMSMapViewDelegate, CLLocationManagerDelegate {
        
        var shouldHandleTap: Bool = true
        
        func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
            print("[] didtapmylocationbutton")
            // 내위치버튼 클릭 시 호출됨
            return false
        }
        
        func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
            print("[] didtapmylocation mapview")
            // 내위치 표시된 곳 클릭할 때
        }
        
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            print("[] change cameraposition")
            // 움직이고난 후 움직였다함
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            print("[] mapview didtap marker")
            // 마커 클릭 시
            return shouldHandleTap
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            print("[] mapview idleat")
            // 움직이고 난 후 멈출 때 표시됨
        }
        
        func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
            print("[] long press")
            // 꾸욱 누르면
        }
    }
    
}
/*
struct GoogleMapView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleMapView()
    }
}
*/
 

struct GooglePlacesView: UIViewControllerRepresentable {
    
    let placeController = GMSAutocompleteViewController()
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    typealias UIViewControllerType = GMSAutocompleteViewController
    
    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        
        self.placeController.delegate = context.coordinator
        
        // self.placeController.present(placeController, animated: true, completion: nil)
        
        return placeController
    }
    
    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {
        
    }
    
    class Coordinator : NSObject, GMSAutocompleteViewControllerDelegate {
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            print("[viewController] place: \(place)")
            
            // fill the text field
            
            // dismiss
            viewController.dismiss(animated: true, completion: nil)
            
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            
            print("[viewController] error: \(error)")
        }
        
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            
            viewController.dismiss(animated: true, completion: nil)
        }
        
        
    }
}

struct PlacePicker: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    @Environment(\.presentationMode) var presentationMode
    @Binding var address: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<PlacePicker>) -> GMSAutocompleteViewController {

        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator


        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
          UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields

        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "KR"
        autocompleteController.autocompleteFilter = filter
        return autocompleteController
    }

    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: UIViewControllerRepresentableContext<PlacePicker>) {
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate {

        var parent: PlacePicker

        init(_ parent: PlacePicker) {
            self.parent = parent
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            DispatchQueue.main.async {
                print(place.description.description as Any)
                self.parent.address =  place.name!
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}

