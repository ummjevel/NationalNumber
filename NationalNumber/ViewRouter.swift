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

struct placeLatLog {
    var placeLatitude : Double
    var placeLongitude : Double
}

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .setting
}

class UserSettings: ObservableObject {
    
    @Published var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    
    var genders = ["기타", "남자", "여자"]
    
    @Published var gender: String {
        didSet {
            UserDefaults.standard.set(gender, forKey: "gender")
        }
    }
    
    @Published var birth: Date {
        didSet {
            UserDefaults.standard.set(birth, forKey: "birth")
        }
    }
    
    @Published var cellphone: String {
        didSet {
            UserDefaults.standard.set(cellphone, forKey: "cellphone")
        }
    }
    
    @Published var cellphone2: String {
        didSet {
            UserDefaults.standard.set(cellphone2, forKey: "cellphone2")
        }
    }
    
    init() {
        self.name = UserDefaults.standard.object(forKey: "name") as? String ?? ""
        self.gender = UserDefaults.standard.object(forKey: "gender") as? String ?? "기타"
        self.birth = UserDefaults.standard.object(forKey: "birth") as? Date ?? Date()
        self.cellphone = UserDefaults.standard.object(forKey: "cellphone") as? String ?? ""
        self.cellphone2 = UserDefaults.standard.object(forKey: "cellphone2") as? String ?? ""
        
    }
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

