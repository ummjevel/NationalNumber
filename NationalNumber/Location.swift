//
//  Location.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/03.
//

import SwiftUI
import GoogleMaps
import GooglePlaces
import MessageUI

struct Location: View {
    
    @State var view_height: CGFloat
    @ObservedObject var viewModel = WebViewModel()
    @State var address = "enter the place."
    @State var showButtonbar = false
    // @ObservedObject var googleModel = GoogleModel()
    @State var googleModel = GoogleModel()
    
    @State var showAlert = false
    
    @State var activeSheet: ActiveSheet?
    @State var halfModal_shown = false
    @State var shareModal_shown = false
    
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                GoogleMapView(view_height: $view_height, googleModel: _googleModel)
                
                VStack {
                    SearchBar(searchKey: $address, googleModel: googleModel, width: geometry.size.width, height: geometry.size.height/12).onTapGesture {
                        activeSheet = .place
                    }.padding(EdgeInsets(top: geometry.size.height/20, leading: 0, bottom: 0, trailing: 0))
                    HStack {
                        Spacer()
                        Button(action: {
                            print("변환 tapped")
                            showAlert = !googleModel.completedSetMarker
                            if(!showAlert) {
                                print("------------------- show alert false search/marker: \(googleModel.completedSearch)/\(googleModel.completedSetMarker)")
                                // halfModal_shown = true
                                // activeSheet = .convert
                                self.viewModel.foo.send(true)
                                self.viewModel.foo2.send(placeLatLog(placeLatitude: googleModel.placeLatitude, placeLongitude: googleModel.placeLongitude))
                                print("------------------- lat,long: \(googleModel.placeLatitude), \(googleModel.placeLongitude)")
                            }
                            print("---------------------------------------------- ")
                            print("placeLatitude: \(googleModel.placeLatitude)")
                            print("placeLongitude: \(googleModel.placeLongitude)")
                            print("completedSearch: \(googleModel.completedSearch)")
                            print("completedSetMarker: \(googleModel.completedSetMarker)")
                            print("completedDidLongPress: \(googleModel.completedDidLongPress)")
                            print("placeName: \(googleModel.placeName)")
                            print("nationalNumber: \(googleModel.nationalNumber)")
                            print("viewportSW: \(googleModel.viewportSW)")
                            print("viewportNE: \(googleModel.viewportNE)")
                            print("---------------------------------------------- ")
                        }) {
                            HStack {
                                Image(systemName: "arrow.left.arrow.right")
                            }
                            .padding()
                            .foregroundColor(.gray)
                            .background(Color.white)
                            .cornerRadius(50)
                        }.alert(isPresented: $showAlert) {
                            Alert(title: Text("위치 지정 후 변환해주세요."),
                                  message: Text("상단의 검색바로 검색하거나 지도를 길게 눌러 마커를 표시하면 위치를 지정할 수 있습니다."),
                                  dismissButton: .default(Text("OK")))
                        }
                        
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 15))
                    .shadow(color: Color.black.opacity(0.3), radius: 4.0, x: 0.0, y: 3.0)
                    /*
                    HStack {
                        Spacer()
                        Button(action: {
                            print("공유 tapped")
                            
                            showAlert = !googleModel.completedSearch
                            if (!showAlert) {
                                // activeSheet = .share
                                halfModal_shown = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                            }
                            .padding()
                            .foregroundColor(.gray)
                            .background(Color.white)
                            .cornerRadius(50)
                        }.alert(isPresented: $showAlert) {
                            Alert(title: Text("위치 지정 후 변환해주세요."),
                                  message: Text("상단의 검색바로 검색하거나 지도를 길게 눌러 마커를 표시하면 위치를 지정할 수 있습니다."),
                                  dismissButton: .default(Text("OK")))
                        }
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .shadow(color: Color.black.opacity(0.3), radius: 4.0, x: 0.0, y: 3.0)
                    */
                    Spacer()
                    WebView(url:"https://ummjevel.github.io/NationalNumber/", viewModel: viewModel).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 0, maxWidth: 0, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight:0, maxHeight: 0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                .onReceive(self.viewModel.bar.receive(on: RunLoop.main)) { value in
                    print("------------------ onReceive ----------------- \(value)")
                }
                .onReceive(self.viewModel.bar2.receive(on: RunLoop.main)) { value in
                    print("------------------ onReceive bar2 ----------------- \(value)")
                    googleModel.nationalNumber = value
                    //activeSheet = .convert
                    halfModal_shown = true
                            // _ = ActionSheet(title: Text("Title"), message: Text(value), buttons: [.default(Text("OK"))])
                    
                }
                .sheet(item: $activeSheet) { item in
                    switch item {
                        case .place:
                            GooglePlacesView(address: $address,
                                             showButtonbar: $showButtonbar,
                                             googleModel: googleModel)
                            
                       //case .message:
                            //MessageView()
                            //ShareSheet(activityItems: ["Hello World"])
                       /* case .convert:
                            CustomActionSheet()
                     */
                    }
                }
                HalfModalView(isShown: $halfModal_shown, modalHeight: 200){
                   
                    VStack {
                        Text("국가지점번호 : \(googleModel.nationalNumber)").padding(EdgeInsets(top: 20, leading: 5, bottom: 5, trailing: 5)).multilineTextAlignment(.leading)
                        Text("위도(lat) : \(googleModel.placeLatitude)").padding(.all, 5).multilineTextAlignment(.leading)
                        Text("경도(long) : \(googleModel.placeLongitude)").padding(.all, 5).multilineTextAlignment(.leading)
                        HStack {
                            Button(action: {
                                print("문자전송 터치")
                                //activeSheet = .message
                                print("전송 번호: \(UserDefaults.standard.string(forKey: "messageRecipients") ?? "")")
                                
                                presentMessageCompose(message: getMessageText(), messageRecipients: UserDefaults.standard.string(forKey: "messageRecipients") ?? "")
                            }) {
                                HStack {
                                    Image(systemName: "arrow.up.message.fill")
                                    Text("구조문자")
                                }
                                .padding(.all, 10)
                                .foregroundColor(.blue)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.blue, lineWidth: 1)
                                )
                            }
                            Button(action: {
                                actionSheet(activityItems: ["\(googleModel.nationalNumber)"])
                            }, label: {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("공유")
                                }
                                .padding(.all, 10)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(30)
                            })
                        }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }// .padding(.all, 10)
                }
                
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
                /*
                .actionSheet(isPresented: $halfModal_shown) {
                    // actionSheet 때문에 LayoutConstraints 가 발생하는데 구글링해보니 uikit bug 라고 함..
                    
                    // ActionSheet(title: Text("경도 : \(googleModel.placeLatitude)\n위도 : \(googleModel.placeLongitude)\n국가지점번호 : \(googleModel.nationalNumber)"), message: Text(""), buttons: [.default(Text(googleModel.nationalNumber)), .default(Text("Share")), .cancel(Text("OK"))])
                    /*ActionSheet(title: Text(""), message: Text(""), buttons: [
                                    .default(Text("위도 : \(googleModel.placeLatitude)")),
                       .default(Text("경도 : \(googleModel.placeLongitude)")),
                       .default(Text("국가지점번호 : \(googleModel.nationalNumber)")),
                       .default(Text("Share")), .cancel(Text("OK"))])
                     */
                    HalfModalView(isShown: $halfModal_shown, modalHeight: 600){
                        Text("hello world")
                    }
                }*/
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
    
    func actionSheet(activityItems: [Any]) {
        // guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func presentMessageCompose(message:String, messageRecipients: String) {

        let messageComposeDelegate = MessageComposeDelegate()

        guard MFMessageComposeViewController.canSendText() else {
            print("---------- cannot send text...")
            let alert = UIAlertController(title: "구조문자 전송 실패", message: "문자 전송이 실패하였습니다.", preferredStyle: .alert)
            let done = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                print("done...")
            }
            alert.addAction(done)
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            
            return
        }
        // let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController

        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        composeVC.recipients = [messageRecipients]
        composeVC.body = message
        UIApplication.shared.windows.first?.rootViewController?.present(composeVC, animated: true, completion: nil)
    }
    
    func getMessageText() -> String {
        
        print("\(UserDefaults.standard.object(forKey: "message") ?? "")\n현위치(lat, long): \(String(format: "%.5f",  googleModel.placeLatitude)), \(String(format: "%.5f", googleModel.placeLongitude))\n국가지점번호: \(googleModel.nationalNumber)")
        
        return "\(UserDefaults.standard.object(forKey: "message") ?? "")\n현위치(lat, long): \(String(format: "%.5f",  googleModel.placeLatitude)), \(String(format: "%.5f", googleModel.placeLongitude))\n국가지점번호: \(googleModel.nationalNumber)"
    }
}

class MessageComposeDelegate: NSObject, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("didFinishWith: \(result)")
        switch result {
            case MessageComposeResult.sent:
                print("sent")
                break
            case MessageComposeResult.cancelled:
                print("cancelled")
                break
            case MessageComposeResult.failed:
                print("failed")
            default:
                print("unknown")
        }
       controller.dismiss(animated: true)
    }
}
