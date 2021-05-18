//
//  ViewRouter.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/03/31.
//

import Foundation
import SwiftUI
import Combine
import GoogleMaps
import GooglePlaces

enum Page {
    case firstaid
    case location
    case setting
}

enum ActiveSheet: Identifiable {
    case place, message //, share, convert
    
    var id: Int {
        hashValue
    }
}

struct placeLatLog {
    var placeLatitude : Double
    var placeLongitude : Double
}

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .location
}

class UserSettings: ObservableObject {
    
    @Published var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
            _ = UpdateMessage()
        }
    }
    
    var genders = ["기타", "남자", "여자"]
    
    @Published var gender: String {
        didSet {
            UserDefaults.standard.set(gender, forKey: "gender")
            _ = UpdateMessage()
        }
    }
    
    @Published var birth: Date {
        didSet {
            UserDefaults.standard.set(birth, forKey: "birth")
            _ = UpdateMessage()
        }
    }
    
    @Published var cellphone: String {
        didSet {
            UserDefaults.standard.set(cellphone, forKey: "cellphone")
            _ = UpdateMessage()
        }
    }
    
    @Published var cellphone2: String {
        didSet {
            UserDefaults.standard.set(cellphone2, forKey: "cellphone2")
            _ = UpdateMessage()
        }
    }
    
    @Published var message: String {
        didSet {
            UserDefaults.standard.set(message, forKey: "message")
        }
    }
    
    @Published var messageRecipients: String {
        didSet {
            UserDefaults.standard.set(messageRecipients, forKey: "messageRecipients")
        }
    }
    
    init() {
        self.name = UserDefaults.standard.object(forKey: "name") as? String ?? ""
        self.gender = UserDefaults.standard.object(forKey: "gender") as? String ?? "기타"
        self.birth = UserDefaults.standard.object(forKey: "birth") as? Date ?? Date()
        self.cellphone = UserDefaults.standard.object(forKey: "cellphone") as? String ?? ""
        self.cellphone2 = UserDefaults.standard.object(forKey: "cellphone2") as? String ?? ""
        self.message = UserDefaults.standard.object(forKey: "message") as? String ?? ""
        self.messageRecipients = UserDefaults.standard.object(forKey: "messageRecipients") as? String ?? "119"
    }
    
    func UpdateMessage() -> String {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 MM월 dd일"
            // formatter.setLocalizedDateFormatFromTemplate("YYYY/MM/dd")
            return formatter
        }()
        
        let body = "이름: \(self.name) \n성별: \(self.gender) \n생년월일 : \(dateFormatter.string(from: self.birth)) \n본인 전화번호: \(ConvertPhoneNumber(phoneNumber: self.cellphone)) \n보호자 전화번호: \(ConvertPhoneNumber(phoneNumber:self.cellphone2))"
        
        self.message = body
        
        return body
    }
    
    
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
    
    
}

class WebViewModel: ObservableObject {
    var foo = PassthroughSubject<Bool, Never>()
    var bar = PassthroughSubject<Bool, Never>()
    
    var foo2 = PassthroughSubject<placeLatLog, Never>()
    var bar2 = PassthroughSubject<String, Never>()
}

class GoogleModel: ObservableObject {
    @Published var completedSearch = false
    @Published var completedSetMarker = false
    @Published var completedDidLongPress = false
    @Published var placeLatitude = 0.0
    @Published var placeLongitude = 0.0
    @Published var viewportSW = CLLocationCoordinate2D()
    @Published var viewportNE = CLLocationCoordinate2D()
    @Published var placeName = ""
    @Published var nationalNumber = ""
}

struct OnboardingData: Hashable, Identifiable {
    let id: Int
    let backgroundImage: String
    let objectImage: String
    let primaryText: String
    let secondaryText: String
    let backOffsetX: CGFloat
    let backOffsetY: CGFloat
    let rectOffsetX1: CGFloat
    let rectOffsetX2: CGFloat
    let maskOffsetX: CGFloat
    let maskOffsetY: CGFloat
    let rotateY: CGFloat

    static let list: [OnboardingData] = [
        
        OnboardingData(id: 0, backgroundImage: "map",  objectImage: "figure.walk", primaryText: "위치를 지정하세요.", secondaryText: "지도 위를 길게 누르거나\n상단의 검색바를 터치하여\n장소를 검색하면 마커를 표시해\n위치를 지정할 수 있습니다.", backOffsetX: 30, backOffsetY: 0, rectOffsetX1: 150, rectOffsetX2: -70, maskOffsetX: 0, maskOffsetY: 50, rotateY: 0),
        OnboardingData(id: 1,  backgroundImage: "message", objectImage: "arrow.left.arrow.right", primaryText: "변환하여 공유하세요.", secondaryText: "마커 표시 후 우측상단의 변환 버튼을 누르면\n국가지점번호로 변환할 수 있습니다.\n결과를 공유하거나 구조문자로 전송할 수 있습니다.", backOffsetX: 30, backOffsetY: 0, rectOffsetX1: 70, rectOffsetX2: -10, maskOffsetX: 0, maskOffsetY: -10, rotateY: 0),
        OnboardingData(id: 2,  backgroundImage: "scroll", objectImage: "pencil.tip", primaryText: "기본 인적사항을 입력해주세요.", secondaryText: "변환 후 구조문자에 전송할 정보입니다.\n구조 시 필요한 기본적인 인적사항입니다.", backOffsetX: 30, backOffsetY: 0, rectOffsetX1: 70, rectOffsetX2: -10, maskOffsetX: 0, maskOffsetY: 40, rotateY: 0),
        OnboardingData(id: 3,  backgroundImage: "person.3", objectImage: "bolt.heart", primaryText: "응급처치를 확인해보세요.", secondaryText: "간단하지만 침착하게 대처할 수 있습니다.\n필요한 순간에 사용하세요.", backOffsetX: 30, backOffsetY: 0, rectOffsetX1: 0, rectOffsetX2: 150, maskOffsetX: 0, maskOffsetY: 0, rotateY: 0)
    ]
}
