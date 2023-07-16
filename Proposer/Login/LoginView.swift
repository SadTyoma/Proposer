//
//  ContentView.swift
//  Proposer
//
//  Created by Artem Shuneyko on 6.04.23.
//

import SwiftUI

struct LoginView: View {
    @State var token: String = ""
    @State private var willMoveToMainScreen = false
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 96, height: 96)
                
                Text("Welcome to Proposer α")
                    .foregroundColor(.whiteText)
                    .font(Font.custom(Constants.notoSansBold, size: Constants.h1TextSize))
                    .lineSpacing(Constants.h1lineSpacing)
                    .kerning(Constants.h1kerning)
                
                Text("Start your onboarding here")
                    .foregroundColor(.whiteText)
                    .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                
                SecureField("", text: $token)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 14)
                    .background(Color.lightBackground)
                    .foregroundColor(Color.white)
                    .cornerRadius(Constants.cornerRadius)
                    .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                    .overlay(
                        Text("Enter token for auth")
                            .foregroundColor(.whiteText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .opacity(token.isEmpty ? 1 : 0)
                    )
                
                Button(action: {
                    // Handle sign in logic
                    checkTocken(token)
                }) {
                    Text("Sign In")
                        .foregroundColor(.purpleText)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(Constants.cornerRadius)
                        .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                }
                
                HStack (spacing: 0){
                    Text("By signing up you agree with our ")
                        .foregroundColor(.whiteText)
                        .font(Font.custom(Constants.notoSans, size: Constants.captionTextSize))
                    
                    Button(action: {
                        // Handle "Terms of service" logic
                    }) {
                        Text("Terms of service")
                            .foregroundColor(.whiteText)
                            .font(Font.custom(Constants.notoSans, size: Constants.captionTextSize))
                            .underline()
                    }
                }
            }
            .frame(maxWidth: 400)
            .background(Color.background)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .onAppear(){
                let savedTocken = loadToken()
                if savedTocken != ""{
                    checkTocken(savedTocken)
                }
            }
        }
        .navigate(to: MainView(), when: $willMoveToMainScreen)
    }
    
    func checkTocken(_ token: String){
        APIWrapper.shared.checkTockenRequest(token) { result in
            switch result {
            case .success(let message):
                saveToken(token)
                willMoveToMainScreen = true
                print(message)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "Token")
    }
    
    private func loadToken() -> String {
        return UserDefaults.standard.string(forKey: "Token") ?? ""
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
