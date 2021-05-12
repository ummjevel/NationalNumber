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

enum ActiveSheet: Identifiable {
    case place//, share, convert
    
    var id: Int {
        hashValue
    }
}

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .location
}

struct placeLatLog {
    var placeLatitude : Double
    var placeLongitude : Double
}

class WebViewModel: ObservableObject {
    var foo = PassthroughSubject<Bool, Never>()
    var bar = PassthroughSubject<Bool, Never>()
    
    var foo2 = PassthroughSubject<placeLatLog, Never>()
    var bar2 = PassthroughSubject<String, Never>()
}

class GoogleModel: ObservableObject {
    @Published var completedSearch = false
    @Published var completedSetMarker = false
    @Published var placeLatitude = 0.0
    @Published var placeLongitude = 0.0
    @Published var viewportSW = CLLocationCoordinate2D()
    @Published var viewportNE = CLLocationCoordinate2D()
    @Published var placeName = ""
    @Published var nationalNumber = ""
}

