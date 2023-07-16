//
//  LastChatsViewModel.swift
//  Proposer
//
//  Created by Artem Shuneyko on 8.04.23.
//

import Foundation

final class LastChatsViewModel : ObservableObject{
    @Published var lastChats: [ChatModelExtended] = []
    
    init(){
        getChats()
    }
    
    func getChats(){
        APIWrapper.shared.loadChats { result in
            DispatchQueue.main.async {
                self.lastChats.removeAll()
                self.lastChats = result
            }
        }
    }
}
