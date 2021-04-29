//
//  FunctionController.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/29.
//

import Foundation
import SwiftUI
import UIKit



struct FunctionControllerView : UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    typealias UIViewControllerType = FunctionController
    
    func makeUIViewController(context: Context) -> FunctionController {
        return FunctionController(isShown: $isShown)
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if (self.isShown) {
            uiViewController.test()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator : NSObject {
        
        var parent: FunctionControllerView
        
        init(_ parent: FunctionControllerView) {
            self.parent = parent
        }
    
    }
}

class FunctionController : UIViewController {
    
    @Binding var isShown: Bool
    
    override func viewDidLoad() {
        print("[FunctionController] viewDidLoad")
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    init(isShown: Binding<Bool>) {
        _isShown = isShown
        print("[FunctionController] init")
        
        super.init(nibName: nil, bundle: nil)
        
        
        let button = UIButton(frame: CGRect(x:100, y:100, width:100, height:100))
        button.backgroundColor = .blue
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        let button2 = UIButton(frame: CGRect(x:200, y:100, width:100, height:100))
        button2.backgroundColor = .black
        button2.setTitle("Test Button2", for: .normal)
        button2.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        self.view.addSubview(button2)
    }
    
    @objc
    func buttonAction() {
        print("[FunctionController]:buttonAction Button tapped!!!!!")
    }
    @objc
    func buttonAction2() {
        print("[FunctionController]:buttonAction2 bye bye")
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func test() {
        print("[FunctionController] test is called..")
        
    }
    
}
