//
//  ChatViewModel.swift
//  Proposer
//
//  Created by Artem Shuneyko on 8.04.23.
//

import Foundation

final class ChatViewModel: ObservableObject{
    @Published var messages: [MessageModel] = []
    @Published var currentId: Int = 0
    
    init(){
        
    }
    
    func resetViewModel(){
        messages = []
        currentId = 0
    }
    
    func loadChat(id: Int){
        currentId = id
        APIWrapper.shared.loadMessages(id: id) { result in
            DispatchQueue.main.async {
                if !result.isEmpty{
                    self.currentId = id
                    self.messages.removeAll()
                    self.messages = result
                }
            }
        }
    }
    
    func sendMessage(text: String, ending: @escaping (Bool)->Void){
        let lastMessageId = messages.last?.id ?? 0
        self.messages.append(MessageModel(id: lastMessageId + 1, author: "user", message: text))
        self.messages.append(MessageModel(id: lastMessageId + 2, author: "assistant", message: ""))
        APIWrapper.shared.sendMessage(text, toChat: currentId) { answer in
            DispatchQueue.main.async {
                var lastMessage = self.messages.removeLast()
                lastMessage.message.append(answer)
                self.messages.append(lastMessage)
                
                self.updateId()
            }
        } finishCompletion: { isEnded in
            ending(isEnded)
        }
    }
    
    func rewriteMessage(messageId: Int, ending: @escaping (Bool)->Void){
        APIWrapper.shared.rewriteMessage(messageId: messageId) { answer in
            DispatchQueue.main.async {
                //TODO: fix this
//                var message = self.messages.first(where: {$0.id == messageId})
//                message!.message = answer
                self.loadChat(id: self.currentId)
                ending(true)
            }
        }
    }
    
    func deleteChat(completion: @escaping (Result<String, Error>) -> Void){
        APIWrapper.shared.deleteChat(withId: currentId) { result in
            switch result {
            case .success:
                print("Chat deleted successfully")
                completion(result)
            case .failure(let error):
                print("Error deleting chat: \(error.localizedDescription)")
                completion(result)
            }
        }
    }
    
    private func updateId(){
        APIWrapper.shared.loadChats { result in
            DispatchQueue.main.async {
                self.currentId = result.last!.id
            }
        }
    }
}
