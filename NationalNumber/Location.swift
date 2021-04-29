//
//  Location.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/03.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

struct Location: View {
    
    @State var view_height: CGFloat
    @ObservedObject var viewModel = WebViewModel()
    @State var address = "enter the place."
    @State var showButtonbar = false
    @ObservedObject var googleModel = GoogleModel()
    /*
    @State var placeLatitude = 0.0
    @State var placeLongitude = 0.0
    @State var viewportSW = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @State var viewportNE = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    */
    @State var showSearchbar = false
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                GoogleMapView(view_height: $view_height, googleModel: _googleModel)
                              /*placeLatitude: $placeLatitude, placeLongitude: $placeLongitude, viewportSW: $viewportSW, viewportNE: $viewportNE,*/
                /* functioncontroller 다 확인되면 다시 풀자!
                WebView(url:"https://ummjevel.github.io/NationalNumber/", viewModel: viewModel).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: geometry.size.width, maxWidth: geometry.size.width, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight:0 /*geometry.size.height/10*/, maxHeight: 0/*/geometry.size.height/10*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                 */
                VStack {
                    SearchBar(searchKey: $address, width: geometry.size.width, height: geometry.size.height/12).onTapGesture {
                        self.showSearchbar = true
                    }
                    HStack {
                        Spacer()
                        /*
                            Button {
                                print("변환")
                            } label: {
                                Text("변환")
                            }.frame(width: 70, height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.3), radius: 4.0, x: 0.0, y: 3.0)
                            */
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .background(Color.white)
                                .padding()
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    print("변환")
                                    if (showButtonbar) {
                                        // 검색 해서 값들이 담겼으니 변환.
                                    } else {
                                        // 선택 먼저 해달라고 안내메시지
                                    }
                                }
                        }
                        .background(Color.white)
                        .cornerRadius(50)
                        .frame(width: 50, height: 50)
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 15))
                    .shadow(color: Color.black.opacity(0.3), radius: 4.0, x: 0.0, y: 3.0)
                    HStack {
                        Spacer()
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .background(Color.white)
                                .padding()
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    print("공유")
                                }
                        }
                        .background(Color.white)
                        .cornerRadius(50)
                        .frame(width: 50, height: 50)
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .shadow(color: Color.black.opacity(0.3), radius: 4.0, x: 0.0, y: 3.0)
                    Spacer()
                        // .padding()
                    /*
                    Rectangle()
                        .cornerRadius(10)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: geometry.size.width, maxWidth: geometry.size.width, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: geometry.size.height/10, maxHeight: geometry.size.height/10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .padding(.all, 10)
                    Spacer()
                    CardView(image: "IMG_5603", title: "라아 8485 1333", width: geometry.size.width, height: geometry.size.height/5)
                    */
                }.sheet(isPresented: $showSearchbar) {
                    GooglePlacesView(address: $address,
                                     showButtonbar: $showButtonbar,
                                     /* placeLatitude: $placeLatitude, placeLongitude: $placeLongitude, viewportSW: $viewportSW, viewportNE: $viewportNE,*/
                                     googleModel: googleModel)
                   
                }
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
