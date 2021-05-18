//
//  ParentOnboardingView.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/05/18.
//

import SwiftUI

struct ParentOnboardingView: View {
    
    @StateObject var viewRouter: ViewRouter
    @State var initShown: Bool = UserDefaults.standard.bool(forKey: "KeyOnBoardingViewShown")
    @State private var currentTab = 0
    
    var body: some View {
        if initShown == false {
            TabView(selection: $currentTab,
                    content:  {
                        ForEach(OnboardingData.list) { viewData in
                            OnboardingView(data: viewData, initShown: $initShown)
                                .tag(viewData.id)
                        }
                    })
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        } else {
            ContentView(viewRouter: viewRouter)
        }
        
    }
}

/*
struct ParentOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ParentOnboardingView(initShow: )
    }
}
*/
