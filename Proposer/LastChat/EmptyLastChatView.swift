//
//  EmptyLastChatView.swift
//  Proposer
//
//  Created by Artem Shuneyko on 6.04.23.
//

import SwiftUI

struct EmptyLastChatView: View {
    @Binding var selectedTabIndex: Int
    
    var body: some View {
        ZStack {
            Color.grayBackground.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                Image("Logo2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64)
                    .foregroundColor(.gray)
                
                Text("Click button below to start new chat")
                    .foregroundColor(.grayText)
                    .font(Font.custom(Constants.notoSans, size: Constants.h2TextSize))
                
                Button(action: {
                    selectedTabIndex = 1
                }) {
                    Text("Start new chat")
                        .foregroundColor(.whiteText)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.background)
                        .cornerRadius(Constants.cornerRadius)
                        .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
    }
}

struct EmptyLastChatView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyLastChatView(selectedTabIndex: .constant(1))
    }
}
