//
//  ChatRowView.swift
//  Proposer
//
//  Created by Artem Shuneyko on 7.04.23.
//

import SwiftUI

struct ChatRowView: View {
    var message: MessageModel
    
    var body: some View {
        let attributedMessage = try! AttributedString(markdown: message.message)
        HStack {
            if message.isUser() {
                Spacer()
                Text(attributedMessage)
                    .font(Font.custom(Constants.notoSans, size: Constants.h2TextSize))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.background)
                    .foregroundColor(.whiteText)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.chatRowCornerRadius, style: .continuous))
                    .listRowSeparator(.hidden)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.title)
                            .rotationEffect(.degrees(-45))
                            .offset(x: 10, y: 10)
                            .foregroundColor(.background)
                    }
                    .fixedSize(horizontal: false, vertical: true)

            } else {
                Text(attributedMessage)
                    .font(Font.custom(Constants.notoSans, size: Constants.h2TextSize))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .foregroundColor(.blackText)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.chatRowCornerRadius, style: .continuous))
                    .listRowSeparator(.hidden)
                    .overlay(alignment: .bottomLeading) {
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.title)
                            .rotationEffect(.degrees(45))
                            .offset(x: -10, y: 10)
                            .foregroundColor(.white)
                    }
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct ChatRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRowView(message: MessageModel(id: 0, author: "assistant", message: """
"Certainly, here are a few tips to avoid making unnecessary pawn moves in chess:

"""))
    }
}
