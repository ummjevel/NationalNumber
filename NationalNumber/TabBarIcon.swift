//
//  TabBarIcon.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/03/31.
//

import SwiftUI

struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
    let width, height: CGFloat
    let systemIconName, tabName: String
    
    var body: some View {
        VStack {
            Image(systemName: systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tabName)
                .font(.footnote)
            Spacer()
        }.padding(.horizontal, -4)
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
        .foregroundColor(viewRouter.currentPage == assignedPage ? Color.red : Color.gray)
    }
}

/*
struct TabBarIcon_Previews: PreviewProvider {
    static var previews: some View {
        TabBarIcon(width: 390.0/3, height: 763.0/28, systemIconName: "figure.walk", tabName: "location")
    }
}
*/
