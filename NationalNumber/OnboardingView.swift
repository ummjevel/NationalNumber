//
//  OnboardingView.swift
//  NationalNumber
//
//  Created by 전민정 on 2021/05/18.
//

import SwiftUI

struct OnboardingView: View {
    
    var data: OnboardingData
    @State private var isAnimating: Bool = false
    @State var animateImage = false
    @Environment(\.colorScheme) var colorScheme
    @Binding var initShown : Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                Image(systemName: data.backgroundImage)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(1.3, contentMode: .fit)
                    .offset(x: data.backOffsetX, y: data.backOffsetY)
                    .foregroundColor(Color.gray)
                VStack {
                    Rectangle()
                        .foregroundColor(Color.red)
                        .frame(width: 150, height: 200, alignment: .center)
                        //.offset(y: 0)
                        .mask(Image(systemName: data.objectImage)
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(1.2, contentMode: .fit)
                                .offset(x: data.maskOffsetX, y: data.maskOffsetY)
                                // .foregroundColor()
                                .rotation3DEffect(
                                    Angle(degrees: animateImage ? 0 : 360),
                                    axis: (x: 0, y: data.rotateY, z: 0)
                                    
                                )
                        )
                        .offset(x: (animateImage ? data.rectOffsetX1 : data.rectOffsetX2))
                        .animation(.linear(duration: 5).repeatForever().repeatForever())
                        .onAppear {
                            animateImage = true
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                }
                
                /*Image(systemName: data.objectImage)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(1.5, contentMode: .fit)
                    .offset(x: 30, y: 100)
                    .foregroundColor(Color.red)*/
                
            }
            Text(data.primaryText)
                .font(.title2)
                .bold()
                .foregroundColor(Color.black)

            Text(data.secondaryText)
                .font(.headline)
                .multilineTextAlignment(.center)
            // .frame(maxWidth: 350)
                .foregroundColor(Color.secondary)
                //.shadow(color: Color.black.opacity(0.1), radius: 1, x: 2, y: 2)
                .padding()
            Button(action: {
                // Add action for button
                UserDefaults.standard.setValue(true, forKey: "KeyOnBoardingViewShown")
                initShown = true
                print("button selected..... initShown: \(initShown), keyonboardingviewshown: \(UserDefaults.standard.bool(forKey: "KeyOnBoardingViewShown"))")
                
            }, label: {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(
                                Color(UIColor.systemRed)
                            )
                    )
            })
            .shadow(radius: 10)
            .padding()
            Spacer()
        }.background(Color(UIColor.systemBackground))
        .onAppear(perform: {
            isAnimating = false
            withAnimation(.easeOut(duration: 0.5)) {
                self.isAnimating = true
            }
        })
    }
}

/*
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(data: OnboardingData.list.first!, initShown: <#T##Binding<Bool>#>)
    }
}
*/
