//
//  NewChatView.swift
//  Proposer
//
//  Created by Artem Shuneyko on 6.04.23.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var showChatViewMenu = false
    @EnvironmentObject var chatVM: ChatViewModel
    @Binding var selectedTabIndex: Int
    @Binding var selectedChatId: Int
    @State var deleteChat = false
    @State var newMessage = ""
    @State var sendingMessage = false
    
    var body: some View {
        ZStack{
            VStack {
                if(chatVM.messages.isEmpty){
                    VStack {
                        Spacer()
                        Image("Logo2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64)
                        
                        Text("Write your first message below")
                            .font(Font.custom(Constants.notoSans, size: Constants.h2TextSize))
                            .foregroundColor(.grayText)
                        
                        Spacer()
                    }
                }
                else {
                    ScrollView {
                        ScrollViewReader { scrollView in
                            VStack {
                                ForEach(chatVM.messages) { message in
                                    ChatRowView(message: message).id(message)
                                        .contextMenu {
                                            Button(action: {
                                                UIPasteboard.general.string = message.message
                                            }) {
                                                Text("Copy")
                                            }
                                            
                                            Button(action: {
                                                let activityViewController = UIActivityViewController(activityItems: [message.message], applicationActivities: nil)
                                                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                                            }) {
                                                Text("Share")
                                            }
                                            
                                            if !message.isUser() {
                                                Button(action: {
                                                    sendingMessage = true
                                                    chatVM.rewriteMessage(messageId: message.id) { idEnded in
                                                        sendingMessage = false
                                                    }
                                                    
                                                }) {
                                                    Text("Rewrite")
                                                }
                                            }
                                        }
                                }
                            }
                            .onChange(of: chatVM.messages.count) { _ in
                                DispatchQueue.main.async {
                                    withAnimation {
                                        scrollView.scrollTo(chatVM.messages.last!, anchor: .bottom)
                                    }
                                }
                            }
                            .onChange(of: chatVM.messages.last!.message, perform: { _ in
                                DispatchQueue.main.async {
                                    withAnimation {
                                        scrollView.scrollTo(chatVM.messages.last!, anchor: .bottom)
                                    }
                                }
                            })
                            .onAppear(){
                                DispatchQueue.main.async {
                                    scrollView.scrollTo(chatVM.messages.last!, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    TextField("", text: $newMessage)
                        .padding(.trailing, 6)
                        .padding(.leading, 12)
                        .padding(.vertical, 8)
                        .overlay(
                            Text("Message")
                                .foregroundColor(.grayText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12)
                                .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                                .opacity(newMessage.isEmpty ? 1 : 0)
                        )
                        .background(Color.grayBackground)
                        .cornerRadius(Constants.chatRowCornerRadius)
                        .padding(.leading, 16)
                        .padding(.top, 8)
                        .onSubmit {
                            if isRecording{
                                speechRecognizer.stopTranscribing()
                            }
                            
                            if !newMessage.isEmpty{
                                chatVM.sendMessage(text: newMessage){ isEnded in
                                    sendingMessage = false
                                }
                                newMessage = ""
                                sendingMessage = true
                            }
                        }
                        .disabled(sendingMessage)
                    
                    Button(action: {
                        if !isRecording {
                            speechRecognizer.transcribe()
                        } else {
                            speechRecognizer.stopTranscribing()
                            if !newMessage.isEmpty {
                                chatVM.sendMessage(text: newMessage){ isEnded in
                                    sendingMessage = false
                                }
                                newMessage = ""
                                sendingMessage = true
                            }
                        }
                        
                        isRecording.toggle()
                    }) {
                        ZStack {
                            Image(systemName: "mic")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.micColor)
                                .cornerRadius(Constants.chatRowCornerRadius)
                                .padding(.top, 8)
                                .opacity(sendingMessage ? 0 : 1)
                            
                            ProgressView()
                                .padding(8)
                                .padding(.top, 8)
                                .opacity(sendingMessage ? 1 : 0)
                        }
                    }
                    .padding(.trailing, 16)
                    .disabled(sendingMessage)
                }
                .onChange(of: speechRecognizer.transcript, perform: { newValue in
                    newMessage = speechRecognizer.transcript
                })
                .onChange(of: sendingMessage, perform: { newValue in
                    
                })
                .padding(.top, 8)
                .frame(height: 40)
                .background(Color.white)
            }
            .background(Color.grayBackground)
            .padding(.bottom, 12)
            .navigationBarTitle(Text(chatVM.messages.count > 0 ? chatVM.messages.first!.message : "New chat"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                self.selectedChatId = 0
                self.selectedTabIndex = 0
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.background)
            }, trailing:
                                    Button(action: {
                showChatViewMenu.toggle()
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.background)
            }
            )
            
            VStack {
                Spacer()
                ChatViewMenu(deleteChat: $deleteChat, showChatViewMenu: $showChatViewMenu)
                    .frame(height: showChatViewMenu ? 200 : 0)
                    .opacity(showChatViewMenu ? 1 : 0)
                    .animation(.easeInOut(duration: 0.25))
            }
            .onChange(of: deleteChat) { newValue in
                if deleteChat{
                    chatVM.deleteChat{ result in
                        deleteChat = false
                        self.selectedChatId = 0
                        self.selectedTabIndex = 0
                    }
                }
            }
        }
        .onTapGesture {
            showChatViewMenu = false
            UIApplication.shared.endEditing()
        }
    }
}

struct NewChatView_Previews: PreviewProvider {
    static let cvm: ChatViewModel = {
        let vm = ChatViewModel()
        vm.messages = [MessageModel(id: 0, author: "assistant", message: """
"Certainly, here are a few tips to avoid making unnecessary pawn moves in chess:
                                    
                                    1. Plan ahead: Think about your long-term strategy and where you want your pieces to be positioned. This will help you avoid making moves that don't contribute to your overall plan.

                                    2. Don't move pawns in front of your king: This weakens your position and can make it easier for your opponent to attack.

                                    3. Be careful about moving pawns on the same color as your bishop: This can block your bishop's mobility and make it less effective.

                                    4. Don't move pawns too far forward too quickly: Moving pawns too far forward can create weaknesses in your position that your opponent can exploit.

                                    5. Use your pawns strategically: Pawns can be used to control space on the board and to support your other pieces. For example, you can use pawns to create a barrier against your opponent's pieces or to protect your own pieces.

                                    Remember, pawns are an important part of the game and can be used to create strong positions on the board. However, it's important to use them wisely and avoid making moves that don't contribute to your overall strategy.
""")]
        
        return vm
    }()
    
    static var previews: some View {
        ChatView(selectedTabIndex: .constant(0), selectedChatId: .constant(0)).environmentObject(cvm)
    }
}

