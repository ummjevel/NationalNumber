//
//  SearchBar.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/27.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchKey: String
    let width, height: CGFloat

    var body: some View {
        ZStack {
            HStack {
                Text(searchKey)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
                Button(action: { self.searchKey = "please enter the place."}) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.secondary)
                }.padding(.all, 10)
            }
        }.background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.3), radius: 4.0, x: 0.0, y: 3.0)
        .padding(.all, 10)
    }
}

/*
struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        // SearchBar(, width: 390.0, height: 763.0/3)
    }
}

 */
