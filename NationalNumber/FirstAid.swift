//
//  FirstAid.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/04/03.
//

import SwiftUI
import WebKit

struct FirstAid: View {
    
    @ObservedObject var viewModel = WebViewModel()
    // @ObservedObject var googleModel = GoogleModel()
    // @State var bar = false
    
    
    var body: some View {
        VStack {
            WebView(url: "http://m.safekorea.go.kr/idsiSFK/neo/main_m/lit/hiking.html", viewModel: viewModel)
                    // , googleModel: googleModel)
            
            
            /*
            WebView(url:"https://ummjevel.github.io/NationalNumber/", viewModel: viewModel)
            HStack {
                Text(bar ? "Before" : "After")

                Button(action: {
                    self.viewModel.foo.send(true)
                    self.viewModel.latitude.send("36.3504119")
                    self.viewModel.longitude.send("127.3845475")
                    
                }) {
                    Text("보내기")
                }

            }*/
             
        }
        /*
        .onReceive(self.viewModel.bar.receive(on: RunLoop.main)) { value in
            self.bar = value
        }
         */
    }
}

struct FirstAid_Previews: PreviewProvider {
    static var previews: some View {
        FirstAid()
    }
}
