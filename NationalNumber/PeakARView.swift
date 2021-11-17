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
    
    
    var userSettings = UserSettings()
    var languageSetting = LanguageSetting.en
    
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
        
        // setUpButtons()
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
        languageSetting = self.userSettings.language == LanguageSetting.en.rawValue ? LanguageSetting.en : LanguageSetting.ko
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        // sceneView.session.pause()
        sceneLocationView.run()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus.rawValue > 2 {
            
            setUpButtons()
            sendCurrentLatLong()
        }
    }
    
    private func setUpButtons() {
        let refreshButton = UIButton(frame: CGRect(x: self.sceneLocationView.frame.width * 0.8, y: 60, width: self.sceneLocationView.frame.width/7, height: self.sceneLocationView.frame.width/7))
        let refreshImage = UIImage(systemName: "arrow.clockwise.circle.fill")
        refreshButton.contentVerticalAlignment = .fill
        refreshButton.contentHorizontalAlignment = .fill
        // refreshImage?.withTintColor(UIColor.gray)
        // refreshButton.backgroundColor = UIColor.white
        refreshButton.tintColor = UIColor.white
        refreshButton.setImage(refreshImage, for: .normal)
        
            //.foregroundColor(.gray)
            //.background(Color.white)
            //.cornerRadius(50)
        // refreshButton.setTitle("Refresh", for: .normal)
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
                    var fixHeight: Float = 4.0
                    var fixArg: Float = 3.0
                    // fixHeight = 4.0
                    
                    if self.languageSetting == LanguageSetting.en {
                        // en
                        for child in responseResult2.body {
                            
                            if fixHeight == 54 {
                                fixArg = -10.0
                            } else if fixHeight == 4 {
                                fixArg = 10.0
                            }
                            fixHeight = fixHeight + fixArg
                            
                            // ar text 표시
                            let placeLocation = CLLocation(latitude: child.lat, longitude: child.lon)
                            
                            // let placeAnnotationNode = PeakMarker(location: placeLocation, title: child.name_en!)
                            let placeAnnotationNode2 = PeakMarker(location: placeLocation, title: child.name_ko!, fixHeight: fixHeight)
                            
                            DispatchQueue.main.async {
                                // self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode)
                                
                                // print(placeAnnotationNode2)
                                
                                self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode2)
                            }
                        }
                    } else if self.languageSetting == LanguageSetting.ko {
                        // en
                        for child in responseResult2.body {
                            
                            if fixHeight == 11 {
                                fixArg = -1
                            } else if fixHeight == 4 {
                                fixArg = 1
                            }
                            fixHeight = fixHeight + fixArg
                            
                            // ar text 표시
                            let placeLocation = CLLocation(latitude: child.lat, longitude: child.lon)
                            // let placeAnnotationNode = PeakMarker(location: placeLocation, title: child.name_ko!)
                            let placeAnnotationNode2 = PeakMarker(location: placeLocation, title: child.name_ko!, fixHeight: fixHeight)
                            
                            DispatchQueue.main.async {
                                // self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode)
                                
                                self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode2)
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
