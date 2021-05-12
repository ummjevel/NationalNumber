//
//  ShareSheet.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/05/11.
//  half modal sheet

import Foundation
import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        print("------------ ShareSheet ------------")
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes //[.postToFacebook, .postToTwitter]//
        //controller.completionWithItemsHandler = callback
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            // To indicate to the hosting view this should be "dismissed"
            print("[ShareSheet] completionWithItemsHandler...")
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
