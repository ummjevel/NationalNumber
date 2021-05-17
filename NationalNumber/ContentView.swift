//
//  ContentView.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/03/31.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewRouter: ViewRouter
    @ObservedObject var userSettings = UserSettings()
    @State var halfModal_shown = false
    
    @State private var currentTab = 0
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        // formatter.setLocalizedDateFormatFromTemplate("YYYY/MM/dd")
        return formatter
    }()
    
    
    var body: some View {
        
        VStack {
            if UserDefaults.standard.bool(forKey: "KeyOnBoardingViewShown") == false {
                TabView(selection: $currentTab,
                        content:  {
                            ForEach(OnboardingData.list) { viewData in
                                OnboardingView(data: viewData)
                                    .tag(viewData.id)
                            }
                        })
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                // UserDefaults.standard.setValue(true, forKey: "KeyOnBoardingViewShown")
            } else {
            
                GeometryReader { geometry in
                    VStack {
                        switch viewRouter.currentPage {
                            case .firstaid:
                                FirstAid()
                            case .location:
                                Location(view_height: geometry.size.height)
                            case .setting:
                                ZStack {
                                    NavigationView {
                                        Form {
                                            Section(header: Text("기본정보"), footer: Text("구조요청 문자 시 전송되는 기본정보입니다.\n내용을 입력 후 엔터 키를 눌러주세요."), content: {
                                                TextField("이름", text: $userSettings.name)
                                                Picker("성별", selection: $userSettings.gender) {
                                                    ForEach(userSettings.genders, id: \.self) { gender in
                                                        Text(gender)
                                                    }
                                                }
                                                HStack {
                                                    Text("생년월일: ")
                                                    Spacer()
                                                    Text("\(userSettings.birth, formatter: Self.dateFormatter)")
                                                }.onTapGesture {
                                                    print("halfmodal shown true")
                                                    halfModal_shown = true
                                                }
                                                /*Text("생년월일: \(userSettings.birth, formatter: Self.dateFormatter)").onTapGesture {
                                                    print("halfmodal shown true")
                                                    halfModal_shown = true
                                                }*/
                                                TextField("본인 전화번호", text: $userSettings.cellphone).keyboardType(.numbersAndPunctuation)
                                                TextField("보호자 전화번호", text: $userSettings.cellphone2).keyboardType(.numbersAndPunctuation)
                                                
                                            })
                                            Section(header: Text("전달내용"), content: {
                                                Text(userSettings.message)
                                                // "이름: \(userSettings.name) \n성별: \(userSettings.gender) \n생년월일 : \(userSettings.birth, formatter: Self.dateFormatter) \n본인 전화번호: \(ConvertPhoneNumber(phoneNumber: userSettings.cellphone)) \n보호자 전화번호: \(ConvertPhoneNumber(phoneNumber:userSettings.cellphone2))"
                                            })
                                            Section(header: Text("신고번호"), footer: Text("구조요청 문자 전송 시 수신하는 전화번호입니다. 예) 119"), content: {
                                                TextField("신고번호", text: $userSettings.messageRecipients).keyboardType(.phonePad)
                                            })
                                        }.navigationTitle("설정")
                                    }.navigationViewStyle(StackNavigationViewStyle())
                                    HalfModalView(isShown: $halfModal_shown, modalHeight: 250){
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Text("Done")
                                                    .bold()
                                                    .onTapGesture {
                                                        halfModal_shown = false;
                                                    }
                                                    
                                            }.foregroundColor(.gray)
                                            .background(Color(UIColor.systemBackground))
                                            .cornerRadius(30)
                                            .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 10))
                                            DatePicker("", selection: $userSettings.birth, in: ...Date(), displayedComponents: [.date]).datePickerStyle(WheelDatePickerStyle())
                                                .environment(\.locale, Locale.init(identifier:"ko_KR"))
                                        }
                                    }
                                }
                        }
                        HStack {
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .firstaid, width: geometry.size.width/3, height: geometry.size.height/28, systemIconName: "bolt.heart", tabName: "응급처치")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .location, width: geometry.size.width/3, height: geometry.size.height/28, systemIconName: "figure.walk", tabName: "위치")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .setting, width: geometry.size.width/3, height: geometry.size.height/28, systemIconName: "gearshape", tabName: "설정")
                        }.frame(width: geometry.size.width, height: geometry.size.height/8)
                        .background(Color(UIColor.systemBackground))
                        
                    }
                    .edgesIgnoringSafeArea((UIDevice.current.orientation.isLandscape && viewRouter.currentPage == .setting) ? .top : .all)
                    //.edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        
    }
}

/*
func ConvertPhoneNumber(phoneNumber: String) -> String {
    var first: String = ""
    var second: String = ""
    var third: String = ""
    
    var firstIndex: String.Index
    var secondIndex: String.Index
    var thirdIndex: String.Index
    
    var firstOffset: Int
    var secondOffset: Int
    var thirdOffset: Int
    
    if(phoneNumber.count == 8) {
        firstOffset = 4
        firstIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: firstOffset)
        secondIndex = phoneNumber.index(firstIndex, offsetBy: firstOffset)
        
        first = String(phoneNumber[..<firstIndex])
        second = String(phoneNumber[firstIndex..<secondIndex])
        
        print("\(first)-\(second)")
        return "\(first)-\(second)"
        
    } else if (phoneNumber.count > 8 && phoneNumber.count <= 11) {
        
        switch phoneNumber.count {
        case 9:
            firstOffset = 2
            secondOffset = 3
            thirdOffset = 4
        case 10:
            firstOffset = 3
            secondOffset = 3
            thirdOffset = 4
        case 11:
            firstOffset = 3
            secondOffset = 4
            thirdOffset = 4
        default:
            return phoneNumber
        }
        
        firstIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: firstOffset)
        secondIndex = phoneNumber.index(firstIndex, offsetBy: secondOffset)
        thirdIndex = phoneNumber.index(secondIndex, offsetBy: thirdOffset)
        
        first = String(phoneNumber[..<firstIndex])
        second = String(phoneNumber[firstIndex..<secondIndex])
        third = String(phoneNumber[secondIndex..<thirdIndex])
        
        print("\(first)-\(second)-\(third)")
        return "\(first)-\(second)-\(third)"
        
    } else {
        return phoneNumber
    }
    
}
*/
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
    }
}
