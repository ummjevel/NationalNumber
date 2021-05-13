//
//  CustomActionSheet.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/05/12.
//
import Foundation
import SwiftUI
import UIKit
import MessageUI

struct MessageView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MFMessageComposeViewController
    
    let messsageController = MFMessageComposeViewController()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        
        
        self.messsageController.recipients = ["01021139911"]
        self.messsageController.body = "hello world.."
        self.messsageController.messageComposeDelegate = context.coordinator
        
        return self.messsageController
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        
    }
    
    class Coordinator : NSObject, MFMessageComposeViewControllerDelegate {
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch result {
            case MessageComposeResult.sent:
                print("전송 완료")
                break
            case MessageComposeResult.cancelled:
                print("전송 취소")
                break
            case MessageComposeResult.failed:
                print("전송 실패")
                break
            @unknown default:
                fatalError()
            }
            controller.dismiss(animated: true, completion: nil)
            
        }
        
        var parent: MessageView
        
        init(_ parent: MessageView) {
            self.parent = parent
        }
        
    }
    
    
}
