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
            WebView(url:
                        // "https://velog.io/"
             "http://m.safekorea.go.kr/idsiSFK/neo/main_m/lit/hiking.html"
            // "https://www.safekorea.go.kr/idsiSFK/neo/main/main.html"
                // "https://www.forest.go.kr/kfsweb/kfi/kfs/cms/cmsView.do?mn=NKFS_02_02_03_01_01&cmsId=FC_001068"
                    // "https://www.safekorea.go.kr/idsiSFK/neo/sfk/cs/contents/prevent/SDIJK14029.html?cd1=29&cd2=999&pagecd=SDIJK140.29&menuSeq=128"
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
