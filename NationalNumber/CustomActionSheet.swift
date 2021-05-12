//
//  CustomActionSheet.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/05/12.
//
import Foundation
import SwiftUI
import UIKit

struct CustomActionSheet: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIAlertController
    
    func makeUIViewController(context: Context) -> UIAlertController {
        let actionSheet = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        let view = UIView(frame: CGRect(x: 8.0, y: 8.0, width: actionSheet.view.bounds.size.width - 8.0 * 4.5, height: 120.0))
        view.backgroundColor = .green
        actionSheet.view.addSubview(view)

        actionSheet.addAction(UIAlertAction(title: "Add to a Playlist", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Create Playlist", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Remove from this Playlist", style: .default, handler: nil))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //actionSheet.presentingViewController?.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        
        return actionSheet
        
            //presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIAlertController, context: Context) {
        
    }
    
}
