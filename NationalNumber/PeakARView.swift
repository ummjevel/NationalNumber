//
//  PeakARView.swift
//  NationalNumber
//
//  Created by 전민정 on 11/13/21.
//

import SwiftUI
import UIKit
import SceneKit
import ARKit
import CoreLocation
import ARCL

struct PeakARView: View {
    var body: some View {
        PeakARViewRepresentable().edgesIgnoringSafeArea(.all)
    }
}

struct PeakARView_Previews: PreviewProvider {
    static var previews: some View {
        PeakARView()
    }
}

// tie together
struct PeakARViewRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PeakARViewController
    
    func makeUIViewController(context: Context) -> PeakARViewController {
        return PeakARViewController()
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        
    }
    
}


class PeakARViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, CLLocationManagerDelegate { //}, CLLocationManagerDelegate {

    // @IBOutlet var sceneView: ARSCNView!
    var sceneView: ARSCNView {
          return self.view as! ARSCNView
       }
       override func loadView() {
         self.view = ARSCNView(frame: .zero)
       }
    
    lazy private var locationManager2 = CLLocationManager()
    
    var sceneLocationView = SceneLocationView()
    var configuration = ARWorldTrackingConfiguration()
    let languageSetting = LanguageSetting.ko
    
    var authState1 : Int = 0
    var authState2 : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // camera displayed
        sceneLocationView.run()
        self.view.addSubview(sceneLocationView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        
        self.locationManager2.delegate = self
        self.locationManager2.desiredAccuracy = kCLLocationAccuracyBest
        // self.locationManager2.requestAlwaysAuthorization()
        self.locationManager2.startUpdatingLocation()
        
        setUpButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // whole screen
        sceneLocationView.frame = self.view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        // let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        // sceneView.session.run(configuration)
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        // sceneView.session.pause()
        sceneLocationView.run()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus.rawValue > 2 {
            sendCurrentLatLong()
        }
    }
    
    private func setUpButtons() {
        let refreshButton = UIButton(frame: CGRect(x: self.sceneView.frame.width - 120, y: 60, width: 100, height: 30))
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        sceneLocationView.addSubview(refreshButton)
        
    }
    
    @objc func sendRequest() {
        sendCurrentLatLong()
    }
    
    func sendCurrentLatLong() {
        
        print("!!!!!!!!!!!!")
        print("\(locationManager2.authorizationStatus.rawValue)")
        print("\(AVCaptureDevice.authorizationStatus(for: AVMediaType.video).rawValue)")
        
        if locationManager2.authorizationStatus == .denied || AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .authorized {
            print("DENIED.... ")
            return
        }
        
        guard let currentLat = locationManager2.location?.coordinate.latitude else {
            print("currentLat is empty.")
            return
        }
        guard let currentLon = locationManager2.location?.coordinate.longitude else {
            print("currentLon is empty.")
            return
        }
        
        print("\(currentLat), \(currentLon)")
        
        request("http://3.145.25.38:9000/api/osm/\(currentLat)/\(currentLon)", "GET") { (success, data) in
            // print(data)
            if success {
                let mirror = Mirror(reflecting: data)
                var resultValue : String = ""
                var bodyValue : [Osm] = []
                var messageValue : String = ""
                for child in mirror.children  {
                    // print("child.label: \(child.label) , child.value: \(child.value)")
                    if child.label == "result" {
                        resultValue = child.value as? String ?? ""
                    } else if child.label == "body" {
                        bodyValue = child.value as? [Osm] ?? []
                    } else if child.label == "message" {
                        messageValue = child.value as? String ?? ""
                    }
                    // print("\(child.value)")
                }
                
                let responseResult2 = Response(result: resultValue, message: messageValue, body: bodyValue)
                
                if responseResult2.result == "OK" {
                    self.sceneLocationView.removeAllNodes()
                    
                    if self.languageSetting == LanguageSetting.en {
                        // en
                        for child in responseResult2.body {
                            // ar text 표시
                            let placeLocation = CLLocation(latitude: child.lat, longitude: child.lon)
                            
                            let placeAnnotationNode = PeakMarker(location: placeLocation, title: child.name_en!)
                            
                            DispatchQueue.main.async {
                                self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode)
                            }
                        }
                    } else if self.languageSetting == LanguageSetting.ko {
                        // en
                        for child in responseResult2.body {
                            // ar text 표시
                            let placeLocation = CLLocation(latitude: child.lat, longitude: child.lon)
                            let placeAnnotationNode = PeakMarker(location: placeLocation, title: child.name_ko!)
                            
                            DispatchQueue.main.async {
                                self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode)
                            }
                        }
                    }
                    
                    // ko
                    print("내가 그림!")
                } else {
                    var titleMessage = "An error is occured. We apologize for the inconvenience of using it."
                    
                    if responseResult2.result == "CREATED" {
                        titleMessage = "No searched data. Please check your location."
                        print("httpstatuscode is 201(CREATED...) nothing in here.")
                    } else {
                        print("httpstatuscode is error...")
                    }
                    
                    self.sceneLocationView.removeAllNodes()
                    let placeLocation = CLLocation(coordinate: self.locationManager2.location!.coordinate, altitude: 1)
                    let placeAnnotationNode = PeakMarker(location: placeLocation, title: titleMessage, markerType: MarkerType.message)
                    self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode)
                  
                }
                
            } else {
                // request error
            }
        }
 
    }
    
}
