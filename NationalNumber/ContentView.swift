//
//  ContentView.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/03/31.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @StateObject var viewRouter: ViewRouter
    @State var allowGPS = true
    @State var name = ""
    @State var gender = 0
    @State var birth = Date()
    @State var fixedDate = ""
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        // formatter.setLocalizedDateFormatFromTemplate("YYYY/MM/dd")
        return formatter
    }()
    
    let genderType = ["기타", "남성", "여성"]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentPage {
                case .firstaid: 
                    FirstAid()
                case .location:
                    Location()
                case .setting:
                    NavigationView {
                        Form {
                            Section(header: Text("GPS"), footer: Text("GPS 권한을 설정합니다."), content: {
                                Toggle(isOn: $allowGPS) {
                                    Text("GPS 허용")
                                }
                            })
                            Section(header: Text("기본정보"), footer: Text("구조요청 문자 시 전송되는 기본정보입니다."), content: {
                                Picker("이름", selection: $name) {
                                    HStack {
                                        TextField("이름을 입력해주세요", text: $name).keyboardType(.default)
                                        Button(action: { self.name = ""}) {
                                            Image(systemName: "multiply.circle.fill")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                Picker("성별", selection: $gender) {
                                    ForEach(0 ..< genderType.count) {
                                        Text("\(self.genderType[$0])")
                                    }
                                }
                                Picker("생년월일", selection: $birth) {
                                    DatePicker("", selection: $birth, in: ...Date(), displayedComponents: [.date]).datePickerStyle(WheelDatePickerStyle())
                                        .environment(\.locale, Locale.init(identifier:"ko_KR"))
                                }
                            })
                            Section(header: Text("전달내용"), content: {
                                name.isEmpty ? Text("이름: 입력없음, \n성별: \(genderType[gender]), \n생년월일 : \(birth, formatter: Self.dateFormatter)") : Text("이름: \(name), \n성별: \(genderType[gender]), \n생년월일 : \(birth, formatter: Self.dateFormatter)")
                            })
                        }.navigationTitle("설정")
                    }.navigationViewStyle(StackNavigationViewStyle())
                }
                Spacer()
                HStack {
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .firstaid, width: geometry.size.width/3, height: geometry.size.height/28, systemIconName: "bolt.heart", tabName: "응급처치")
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .location, width: geometry.size.width/3, height: geometry.size.height/28, systemIconName: "figure.walk", tabName: "위치")
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .setting, width: geometry.size.width/3, height: geometry.size.height/28, systemIconName: "gearshape", tabName: "설정")
                }.frame(width: geometry.size.width, height: geometry.size.height/8)
                // .background(Color("TabBarBackground").shadow(radius:2))
                
            }.edgesIgnoringSafeArea(.bottom)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
    }
}
