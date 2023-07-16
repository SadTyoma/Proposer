//
//  LastChatCell.swift
//  Proposer
//
//  Created by Artem Shuneyko on 6.04.23.
//

import SwiftUI

struct LastChatCell: View {
    @State var message = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            if message.count > 100 {
                Text(String(message.prefix(100)) + "...")
                    .padding(.horizontal,12)
            } else {
                Text(message).padding(.horizontal,12)
            }
        }
        .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
        .foregroundColor(.grayText2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .foregroundColor(.black)
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color.white)
                .padding(.horizontal, 12)
        )
    }
}


struct LastChatCell_Previews: PreviewProvider {
    static var previews: some View {
        LastChatCell(message: "Hello, world! This is a long message that will be truncated if it's over 100 characters.")
    }
}
