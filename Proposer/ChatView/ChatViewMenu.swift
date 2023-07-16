//
//  ChatViewMenu.swift
//  Proposer
//
//  Created by Artem Shuneyko on 7.04.23.
//

import SwiftUI

struct ChatViewMenu: View {
    @State private var showAlert = false
    @Binding var deleteChat: Bool
    @Binding var showChatViewMenu : Bool
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Button(action: {
                    showAlert = true
                }) {
                    Text("Delete chat")
                        .foregroundColor(.red)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(Constants.cornerRadius)
                        .font(Font.custom(Constants.notoSans, size: 20))
                }
                
                Button(action: {
                    showChatViewMenu = false
                }) {
                    Text("Cancel")
                        .foregroundColor(.purpleText)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(Constants.cornerRadius)
                        .font(Font.custom(Constants.notoSans, size: 20))
                }
            }
            .padding(.bottom)
            .padding(.horizontal, 12)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete this chat?")
                        .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize)),
                    message: Text("It will be deleted forever. You won’t be able to restore it.")
                        .font(Font.custom(Constants.notoSans, size: Constants.h3TextSize)),
                    primaryButton:
                            .default(Text("Cancel")
                                .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                                .foregroundColor(.purpleText)) {
                                    showAlert = false
                                    showChatViewMenu = false
                                }
                    ,
                    secondaryButton: .destructive(Text("Delete")
                        .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))) {
                            deleteChat = true
                            showAlert = false
                            showChatViewMenu = false
                        }
                )
            }
        }
        .background(Color.clear)
        .cornerRadius(Constants.cornerRadius)
        .padding(.horizontal)
        .padding(.bottom, 12)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ChatViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewMenu(deleteChat: .constant(false), showChatViewMenu: .constant(false))
    }
}

