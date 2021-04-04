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
    @State var bar = false
    
    var body: some View {
        VStack {
            WebView(url: "http://m.safekorea.go.kr/idsiSFK/neo/main_m/lit/hiking.html"
                    , viewModel: viewModel)
            /*            HStack {
                Text(bar ? "Before" : "After")

                Button(action: {
                    self.viewModel.foo.send(true)
                }) {
                    Text("보내기")
                }

            }
             */
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
