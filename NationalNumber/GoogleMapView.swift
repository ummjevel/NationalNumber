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
        Coordinator(self)
    }
    
    @Binding var view_height: CGFloat
    @ObservedObject var googleModel: GoogleModel
    
    /*
    @Binding var placeLatitude: CLLocationDegrees
    @Binding var placeLongitude: CLLocationDegrees
    @Binding var viewportSW: CLLocationCoordinate2D
    @Binding var viewportNE: CLLocationCoordinate2D
    */
    
    typealias UIViewType = GMSMapView
    
    private static let defaultCamera = GMSCameraPosition.camera(withLatitude: 38.1206, longitude: 128.4654, zoom: 10.0)
    // (withLatitude: -33.86, longitude: 151.20, zoom: 6.0) // 38.12067304510615, 128.46542415288081
    // (withLatitude: 37.5484, longitude: 127.0534, zoom: 10.0)
    private let mapView : GMSMapView
    // private weak var mapDelegate: GMSMapViewDelegateWrapper?
    let marker : GMSMarker = GMSMarker()
    // var marker : GMSMarker?

    init(view_height: Binding<CGFloat>, googleModel: ObservedObject<GoogleModel>
         /*, placeLatitude: Binding<CLLocationDegrees>, placeLongitude: Binding<CLLocationDegrees>, viewportSW: Binding<CLLocationCoordinate2D>, viewportNE: Binding<CLLocationCoordinate2D>*/) {
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
        self._googleModel = googleModel
        /*
        self._placeLatitude = placeLatitude
        self._placeLongitude = placeLongitude
        self._viewportSW = viewportSW
        self._viewportNE = viewportNE
        */
        // mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self._view_height.wrappedValue/10 , right: 0)
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
        
        // 검색으로 이동한 경우
        if (googleModel.completedSearch) {
            uiView.moveCamera(GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: googleModel.viewportNE, coordinate: googleModel.viewportSW), withPadding: 50.0))
            uiView.clear() // self.marker.map = nil
            self.marker.position = CLLocationCoordinate2D(latitude: googleModel.placeLatitude, longitude: googleModel.placeLongitude)
            self.marker.title = self.googleModel.placeName
            self.marker.map = uiView
            print("--------------- current marker title is \(self.googleModel.placeName)")
        }
        // long press로 marker 를 찍은 경우 외 : else..
        /*
        if ((googleModel.placeLatitude == 0.0) && (googleModel.placeLongitude == 0.0)) {
            
        } else {
            // let currentMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: googleModel.placeLatitude, longitude: googleModel.placeLongitude))
            // marker.position =
            // marker.map = mapView // 안됨!
            // currentMarker.title = "hiker11" // googleModel.placeName
            // currentMarker.tracksViewChanges = true
            // currentMarker.isDraggable = true
            // currentMarker.map = uiView
            // marker.title = googleModel.placeName
            //marker.map = uiView
            // mapView.camera = GMSCameraPosition.camera(withLatitude: placeLatitude, longitude: placeLongitude, zoom: 10.0)
            // mapView.animate(to: GMSCameraPosition.camera(withLatitude: placeLatitude, longitude: placeLongitude, zoom: 15.0))
            
            
            // uiView.moveCamera(GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: googleModel.viewportNE, coordinate: googleModel.viewportSW), withPadding: 50.0))
            
            //self.marker.position = CLLocationCoordinate2D(latitude: googleModel.placeLatitude, longitude: googleModel.placeLongitude)
            //self.marker.title = self.googleModel.placeName
            //self.marker.map = self.mapView
            
            
        }*/
        
        // print("marker.position: \(marker.position)")
        // print("marker.title: \(String(describing: marker.title))")
        print("current googleModel.placeName: \(googleModel.placeName)")
        print("current googleModel.placeLatitude: \(googleModel.placeLatitude)")
        print("current googleModel.placeLongitude: \(googleModel.placeLongitude)")
        print("current latitude1: \(uiView.camera.target.latitude)")
        print("current longitude1: \(uiView.camera.target.longitude)")
        
        //marker.position = CLLocationCoordinate2D(latitude: googleModel.placeLatitude, longitude: googleModel.placeLongitude)
        //marker.title = "hello"
        //marker.map = uiView // self.mapView
        
        // (latitude: 38.1206, longitude: 128.4654)
        // (latitude: -33.86, longitude: 151.20)
        /*
        marker.position = CLLocationCoordinate2D(latitude: googleModel.placeLatitude, longitude: googleModel.placeLongitude)
        marker.title = "설악산 대청봉"
        marker.snippet = "전민정 다리 부서진 곳"
        marker.map = uiView
         */
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
        
        var parent: GoogleMapView
        
        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        
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
            mapView.clear()
            self.parent.marker.position = coordinate
            // self.parent.marker.title = "Hello World"
            self.parent.marker.map = mapView // self.parent.mapView
            let bounds = GMSCoordinateBounds(coordinate: mapView.projection.visibleRegion().nearLeft, coordinate: mapView.projection.visibleRegion().farRight)
            self.parent.googleModel.viewportSW = bounds.southWest
            self.parent.googleModel.viewportNE = bounds.northEast
            self.parent.googleModel.placeLatitude = coordinate.latitude
            self.parent.googleModel.placeLongitude = coordinate.longitude
            self.parent.googleModel.completedSetMarker = true
            self.parent.googleModel.placeName = ""
            self.parent.googleModel.completedSearch = true
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
    
    @Binding var address: String
    @Binding var showButtonbar: Bool
    @ObservedObject var googleModel: GoogleModel
    /*
    @Binding var placeLatitude: CLLocationDegrees
    @Binding var placeLongitude: CLLocationDegrees
    @Binding var viewportSW: CLLocationCoordinate2D
    @Binding var viewportNE: CLLocationCoordinate2D
    */
    
    let placeController = GMSAutocompleteViewController()
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    typealias UIViewControllerType = GMSAutocompleteViewController
    
    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        print("GooglePlacesView: makeUIViewController")
        self.placeController.delegate = context.coordinator
        
        // self.placeController.present(placeController, animated: true, completion: nil)
        
        return placeController
    }
    
    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {
        
    }
    
    class Coordinator : NSObject, GMSAutocompleteViewControllerDelegate {
        
        var parent: GooglePlacesView
        
        init(_ parent: GooglePlacesView) {
            self.parent = parent
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            print("[viewController] place: \(place)")
            
            // fill the text
            self.parent.address = place.name ?? ""
            
            
            self.parent.googleModel.placeLatitude = place.coordinate.latitude
            self.parent.googleModel.placeLongitude = place.coordinate.longitude
            self.parent.googleModel.viewportSW = place.viewport?.southWest ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            self.parent.googleModel.viewportNE = place.viewport?.northEast ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            self.parent.googleModel.placeName = place.name ?? ""
            self.parent.googleModel.completedSearch = true
            
            /*
            self.parent.googleModel.placeLatitude.send(place.coordinate.latitude)
            self.parent.googleModel.placeLongitude.send(place.coordinate.longitude)
            self.parent.googleModel.viewportSW.send(place.viewport?.southWest ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
            self.parent.googleModel.viewportNE.send(place.viewport?.northEast ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
             */
            
            self.parent.showButtonbar = true
            
            // weak var pvc = viewController.presentingViewController
            
            // dismiss
            viewController.dismiss(animated: true, completion: {
                /* 일단 레이아웃 하는 것 부터 되는지 확인해보고..
                let vc = FunctionController(isShown: self.parent.$showButtonbar)
                vc.modalPresentationStyle = .currentContext
                vc.modalTransitionStyle = .coverVertical
                pvc?.present(vc, animated: true, completion: nil)
                */
            })
            
            // FunctionControllerView.init(isShown: self.parent.$isShown)
            
            // viewController.modalPresentationStyle = .currentContext
            // viewController.present(viewController, animated: true, completion: nil)
            
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            
            print("[viewController] error: \(error)")
        }
        
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            
            viewController.dismiss(animated: true, completion: nil)
            
        }
        
        
    }
}


/*
struct FunctionController: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    typealias UIViewControllerType = UIViewController
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        let functionController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return functionController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        <#code#>
    }
    
    class Coordinator : NSObject, UIPageViewControllerDelegate {
        
        var parent: FunctionController
        
        init(_ parent: FunctionController) {
            self.parent = parent
        }
    }
}*/

/*
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

*/
