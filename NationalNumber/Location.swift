//
//  Location.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/03.
//

import SwiftUI

struct Location: View {
    
    @State var view_height: CGFloat
    @ObservedObject var viewModel = WebViewModel()
    @State var address = "enter the place."
    @State var showSearchbar = false
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                GoogleMapView(view_height: $view_height)
                
                WebView(url:"https://ummjevel.github.io/NationalNumber/", viewModel: viewModel).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: geometry.size.width, maxWidth: geometry.size.width, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight:0 /*geometry.size.height/10*/, maxHeight: 0/*/geometry.size.height/10*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                VStack {
                    SearchBar(searchKey: $address, width: geometry.size.width, height: geometry.size.height/12).onTapGesture {
                        self.showSearchbar = true
                    }
                    Spacer()
                    /*
                    Rectangle()
                        .cornerRadius(10)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: geometry.size.width, maxWidth: geometry.size.width, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: geometry.size.height/10, maxHeight: geometry.size.height/10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .padding(.all, 10)
                    Spacer()
                    CardView(image: "IMG_5603", title: "라아 8485 1333", width: geometry.size.width, height: geometry.size.height/5)
                    */
                }.sheet(isPresented: $showSearchbar) { GooglePlacesView() }
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

/*
struct Location_Previews: PreviewProvider {
    static var previews: some View {
        Location()
    }
}
*/
