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

protocol MessagesViewDelegate {
    func messageCompletion(result: MessageComposeResult)
}

class MessagesViewController : UIViewController { //}, MFMessageComposeViewControllerDelegate {
    
    var delegate: MessagesViewDelegate?
    var recipients: [String]?
    var body: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // definesPresentationContext = true
    }
    
    func displayMessageInterface(composeVC: MFMessageComposeViewController) {
        // let composeVC = MFMessageComposeViewController()
        // composeVC.messageComposeDelegate = self
        
        composeVC.recipients = self.recipients ?? []
        composeVC.body = body ?? ""
        
        print("MessagesViewController [displayMessageInterface]-----------------------------")
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            self.delegate?.messageCompletion(result:MessageComposeResult.failed)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.messageCompletion(result: result)
    }
}

struct MessageView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    var completion: ((_ result: MessageComposeResult) -> Void)
    
    @State var message: String
    @State var messageRecipients: [String]
    
    typealias UIViewControllerType = MFMessageComposeViewController
    
    let messsageController = MFMessageComposeViewController()
    // let messageControlller2 = MessagesViewController()
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        
        /*let controller = MessagesViewController()
        controller.delegate = context.coordinator
        controller.recipients = messageRecipients
        controller.body = message
        return controller
        */
        // messageControlller2.displayMessageInterface(composeVC: messsageController)
        print("MessageView [makeUIViewController]-----------------------------")
        self.messsageController.recipients = messageRecipients // ["01021139911"]
        self.messsageController.body = message // "hello world.."
        self.messsageController.messageComposeDelegate = context.coordinator
        
        return self.messsageController
         
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        uiViewController.recipients = messageRecipients
        uiViewController.body = message
        // uiViewController.displayMessageInterface()
        
        print("MessageView [updateUIViewController]-----------------------------")
    }
    
    class Coordinator : NSObject, UINavigationControllerDelegate, MessagesViewDelegate, MFMessageComposeViewControllerDelegate { // , MFMessageComposeViewControllerDelegate {
        
        func messageCompletion(result: MessageComposeResult) {
            
            print("MessageView [messageCompletion]-----------------------------")
            self.parent.presentationMode.wrappedValue.dismiss()
            self.parent.completion(result)
        }
        
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
            print("MessageView [messageComposeViewController]-----------------------------")
            controller.dismiss(animated: true, completion: nil)
            
        }
        
        var parent: MessageView
        
        init(_ parent: MessageView) {
            self.parent = parent
        }
        
    }
    
    
}
