//
//  ViewRouter.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/03/31.
//

import Foundation
import SwiftUI
import Combine

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
