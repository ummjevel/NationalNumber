//
//  ViewRouter.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/03/31.
//

import Foundation
import SwiftUI
import Combine
import GoogleMaps
import GooglePlaces

enum Page {
    case firstaid
    case location
    case setting
}

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .location
}

class WebViewModel: ObservableObject {
    var foo = PassthroughSubject<Bool, Never>()
    var bar = PassthroughSubject<Bool, Never>()
    
    var latitude = PassthroughSubject<String, Never>()
    var longitude = PassthroughSubject<String, Never>()
}

class GoogleModel: ObservableObject {
    /*
    var placeLatitude = PassthroughSubject<CLLocationDegrees, Never>()
    var placeLongitude = PassthroughSubject<CLLocationDegrees, Never>()
    var viewportSW = PassthroughSubject<CLLocationCoordinate2D, Never>()
    var viewportNE = PassthroughSubject<CLLocationCoordinate2D, Never>()
    var placeName = PassthroughSubject<String?, Never>()
    */
    @Published var placeLatitude = 0.0
    @Published var placeLongitude = 0.0
    @Published var viewportSW = CLLocationCoordinate2D()
    @Published var viewportNE = CLLocationCoordinate2D()
    @Published var placeName = ""
    
}
