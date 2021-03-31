//
//  ViewRouter.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/03/31.
//

import Foundation
import SwiftUI

enum Page {
    case firstaid
    case location
    case setting
}

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .setting
}

