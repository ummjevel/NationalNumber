//
//  WebView.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/03.
//

import SwiftUI

import UIKit // UIViewRepresentable
import Combine
import WebKit

struct WebView: UIViewRepresentable {
    
    var url: String
    // @ObservedObject var viewModel: WebViewModel
    @State var viewModel: WebViewModel
    
    // @ObservedObject var googleModel: GoogleModel
    
    func makeCoordinator() -> Coordinator {
        // UIViewRepresentable 필수
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        print("[WebView] makeUIView")
        // UIViewRepresentable 필수
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let contentController = WKUserContentController()
        contentController.add(self.makeCoordinator(), name: "test")    // bridge 연결
        configuration.userContentController = contentController
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        webView.addSubview(context.coordinator.indicator)
        
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
            
            if self.url == "https://ummjevel.github.io/NationalNumber/" {
                webView.scrollView.isScrollEnabled = false
            }
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // UIViewRepresentable 필수
        print("[WebView] updateUIView")
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if(message.name == "test") {
                print("call func: test-----------")
                nationalNumber = message.body
                print("nationalNumber: ")
                print(self.nationalNumber)
                // parent.googleModel.nationalNumber = nationalNumber as? String ?? ""
                
                // print("parent.googleModel.nationalNumber \(parent.googleModel.nationalNumber)")
                
            }
        }
        
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        
        var parent: WebView
        var foo: AnyCancellable? = nil
        var foo2: AnyCancellable? = nil
        // var longitude: AnyCancellable? = nil
        // var latitude: AnyCancellable? = nil
        var nationalNumber: Any = ""
        
        init(_ uiWebView: WebView) {
            self.parent = uiWebView
            print("[WebView] init")
            
            
        }
        
        deinit {
            foo?.cancel()
            foo2?.cancel()
            // longitude?.cancel()
            // latitude?.cancel()
            print("[WebView] deinit")
        }
        
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
                        
            /*if let host = navigationAction.request.url?.host {
                if host != '접근비허용 특정도메인' {
                    return decisionHandler(.cancel)
                }
            }*/
            /*
            parent.viewModel.bar.send(false)
            
            self.foo = self.parent.viewModel.foo.receive(on: RunLoop.main).sink(receiveValue: { value in
                print(value)
            })
            
            self.longitude = self.parent.viewModel.longitude.receive(on: RunLoop.main).sink(receiveValue: { value in
                print("longitude: " + value)
            })
            
            self.latitude = self.parent.viewModel.latitude.receive(on: RunLoop.main).sink(receiveValue: { value in
                print("latitude: " + value)
            })
            */
            
            print("[WebView] decidePolicyFor")
            
            
            
            
            
            return decisionHandler(.allow)
                     
         }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("기본 프레임에서 탐색 시작")
            self.indicator.center = webView.center
            self.indicator.startAnimating()
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("내용 수신 시작")
        }
        
        func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
            print("탐색 완료")
            self.indicator.stopAnimating()
            
            self.foo = self.parent.viewModel.foo.receive(on: RunLoop.main).sink(receiveValue: { value in
                        print("--------------------- foo.receive  : \(value)")
            })
            
            self.foo2 = self.parent.viewModel.foo2.receive(on: RunLoop.main).sink(receiveValue: { value in
                print("--------------------- foo2.receive  : \(value.placeLatitude), \(value.placeLongitude)")
                webView.evaluateJavaScript("convert2NN('\(value.placeLatitude)','\(value.placeLongitude)')") { [self] (result, error) in
                    if let anError = error {
                        print("Error: \(anError)")
                    }
                    print("Result: \(result ?? "")")
                    if let result = result {
                        print("hihihihihi           \(result)")
                        
                        parent.viewModel.bar2.send(result as! String)
                    }
                }
            })
            
            /*
            if(parent.googleModel.completedSearch) {
                print("googleModel.placeLatitude: \(parent.googleModel.placeLatitude)")
                print("googleModel.placeLongitude: \(parent.googleModel.placeLongitude)")
                
                
                print("start evalute: ")
                
                //convert2NN(36.3504119,127.3845475)
                webview.evaluateJavaScript("convert2NN('\(parent.googleModel.placeLatitude)','\(parent.googleModel.placeLongitude)')") { (result, error) in
                    if let anError = error {
                        print("Error: \(anError)")
                    }
                    print("Result: \(result ?? "")")
                }
                
                /*
                webView.evaluateJavaScript("test()", completionHandler: { result, error in
                    if let anError = error {
                        print("Error \(anError.localizedDescription)")
                        print(anError)
                    }
                    
                    print("Result \(result ?? "")")
                })*/
                print("end evalute: ")
            }
            */
            
            
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("탐색 중 오류 발생")
            self.indicator.stopAnimating()
        }
        
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            print("웹 컨텐츠가 종료될 때 호출")
        }
        
        
        
    }
}
