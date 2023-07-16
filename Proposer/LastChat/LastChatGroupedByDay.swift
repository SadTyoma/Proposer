//
//  LastChatDayGroup.swift
//  Proposer
//
//  Created by Artem Shuneyko on 6.04.23.
//

import SwiftUI

struct LastChatGroupedByDay: View {
    @EnvironmentObject var chatsVM: LastChatsViewModel
    @Binding var selectedTabIndex: Int
    @Binding var selectedChatId: Int
    @Binding var searchText: String
    
    var filteredChats: [ChatModelExtended] {
        if searchText.isEmpty {
            return chatsVM.lastChats
        } else {
            return chatsVM.lastChats.filter { $0.title.contains(searchText) }
        }
    }
    
    var body: some View {
        let groupedMessages = Dictionary(grouping: filteredChats) { $0.comparableDate }
        let sortedDays = groupedMessages.keys.sorted().reversed()
        
        ZStack {
            Color.grayBackground.edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    ForEach(sortedDays, id: \.self) { day in
                        Section(header: Text(day.day)
                            .foregroundColor(.grayText2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.horizontal, .top], 12)
                            .font(.system(size: Constants.baseTextSize))
                            .bold()
                        ) {
                            ForEach(groupedMessages[day]!.reversed()) { message in
                                LastChatCell(message: message.title)
                                    .onTapGesture {
                                        selectedChatId = message.id
                                    }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.bottom, 10)
        }
    }
}

struct LastChatDayGroup_Previews: PreviewProvider {
    static let lastChatsVM: LastChatsViewModel = {
        let lchVM = LastChatsViewModel()
        lchVM.lastChats = lastChatsPreviewData
        
        return lchVM
    }()
    
    static var previews: some View {
        LastChatGroupedByDay(selectedTabIndex: .constant(2), selectedChatId: .constant(0), searchText: .constant("")).environmentObject(lastChatsVM)
    }
}
