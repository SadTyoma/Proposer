//
//  LastChatsView.swift
//  Proposer
//
//  Created by Artem Shuneyko on 6.04.23.
//

import SwiftUI

struct LastChatsView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var isRecording = false
    @EnvironmentObject var chatsVM: LastChatsViewModel
    @Binding var selectedTabIndex: Int
    @Binding var selectedChatId: Int
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Last chats")
                    .foregroundColor(.whiteText)
                    .font(Font.custom(Constants.notoSansBold, size: Constants.h1TextSize))
                    .lineSpacing(Constants.h1lineSpacing)
                    .kerning(Constants.h1kerning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.white)
                        
                        TextField("", text: $searchText)
                            .overlay(
                                Text("Search")
                                    .foregroundColor(.whiteText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .opacity(searchText.isEmpty ? 1 : 0)
                                    .onSubmit {
                                        if isRecording{
                                            speechRecognizer.stopTranscribing()
                                        }
                                        isSearching = false
                                        isRecording = false
                                    }
                            )
                            .foregroundColor(.whiteText)
                            .onTapGesture {
                                isSearching = true
                            }
                        
                        Button(action: {
                            if isRecording {
                                speechRecognizer.stopTranscribing()
                            }else{
                                isSearching = true
                                speechRecognizer.transcribe()
                            }
                            isRecording.toggle()
                            UIApplication.shared.endEditing()
                        }) {
                            Image(systemName: "mic.fill")
                                .foregroundColor(Color.white)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.lightBackground)
                    .cornerRadius(10)
                    if isSearching {
                        Button(action: {
                            self.searchText = ""
                            if isRecording {
                                speechRecognizer.stopTranscribing()
                            }
                            isSearching = false
                            isRecording = false
                            UIApplication.shared.endEditing()
                        }) {
                            Text("Cancel")
                                .foregroundColor(.whiteText)
                        }
                    }
                }
                .padding(.horizontal, 12)
                
                if(chatsVM.lastChats.isEmpty){
                    EmptyLastChatView(selectedTabIndex: $selectedTabIndex)
                        .padding(.top, 6)
                }
                else{
                    LastChatGroupedByDay(selectedTabIndex: $selectedTabIndex, selectedChatId: $selectedChatId, searchText: $searchText).environmentObject(chatsVM)
                        .padding(.top, 6)
                }
            }
        }
        .onChange(of: speechRecognizer.transcript) { newValue in
            searchText = speechRecognizer.transcript
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct LastChatsView_Previews: PreviewProvider {
    static let lastChatsVM: LastChatsViewModel = {
        let lchVM = LastChatsViewModel()
        lchVM.lastChats = lastChatsPreviewData
        
        return lchVM
    }()
    
    static var previews: some View {
        LastChatsView(selectedTabIndex: .constant(1), selectedChatId: .constant(0)).environmentObject(lastChatsVM)
    }
}
