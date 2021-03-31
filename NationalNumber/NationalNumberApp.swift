//
//  NationalNumberApp.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/03/31.
//

import SwiftUI

@main
struct NationalNumberApp: App {
    
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewRouter: viewRouter)
        }
    }
}
