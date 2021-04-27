//
//  NationalNumberApp.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/03/31.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

let googleApiKey = "AIzaSyDB5k7_v016Zz4nj-DpSdZpv6D-A2-5CKE"

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(">> your code here !!")
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)
        return true
    }
}

@main
struct NationalNumberApp: App {
    
    @StateObject var viewRouter = ViewRouter()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView(viewRouter: viewRouter)
        }
    }
}
