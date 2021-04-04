//
//  CardView.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/05.
//

import SwiftUI

struct CardView: View {

    var image: String
    var title: String
    let width, height: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(20)
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: width, maxWidth: width, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: height, maxHeight: height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.secondary)
                .padding(.all, 10)
                
            /*Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)*/
            Text(title)
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(image: "IMG_5603", title: "라아 8485 1333", width: 390.0, height: 763.0/3)
    }
}
