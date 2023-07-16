//
//  MainView.swift
//  Proposer
//
//  Created by Artem Shuneyko on 6.04.23.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTabIndex = 0
    @State private var selectedChatId = 0
    @StateObject private var lastChatsVM = LastChatsViewModel()
    @StateObject private var chatVM = ChatViewModel()
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTabIndex) {
                LastChatsView(selectedTabIndex: $selectedTabIndex, selectedChatId: $selectedChatId).environmentObject(lastChatsVM)
                    .tabItem(){
                        Image(systemName: "message")
                        Text("Last chats")
                            .font(Font.custom(Constants.notoSans, size: Constants.h3TextSize))
                    }
                    .tag(0)
                
                Text("")
                .tabItem(){
                    Image(systemName: "plus")
                    Text("New chat")
                        .font(Font.custom(Constants.notoSans, size: Constants.h3TextSize))
                }
                .tag(1)
                
                ImportDataView()
                    .tabItem(){
                        Image(systemName: "rectangle.stack.badge.plus")
                        Text("Data")
                            .font(Font.custom(Constants.notoSans, size: Constants.h3TextSize))
                        
                    }
                    .tag(2)
            }
            .accentColor(.purpleText)
            .onChange(of: selectedChatId) { newValue in
                if newValue == 0{
                    chatVM.resetViewModel()
                }
                else{
                    chatVM.loadChat(id: newValue)
                    selectedTabIndex = 1
                }
            }
            
            if selectedTabIndex == 1{
                NavigationView{
                    ChatView(selectedTabIndex: $selectedTabIndex, selectedChatId: $selectedChatId).environmentObject(chatVM)
                    
                }
            }
        }
        .onChange(of: selectedTabIndex) { newValue in
            if newValue == 0{
                chatVM.resetViewModel()
                lastChatsVM.getChats()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
