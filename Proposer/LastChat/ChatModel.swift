//
//  LastMessageModel.swift
//  Proposer
//
//  Created by Artem Shuneyko on 6.04.23.
//

import Foundation

struct ChatModel: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id = "chat_id"
        case title = "chat_title"
        case date = "chat_date"
    }
    
    static func ==(lhs: ChatModel, rhs: ChatModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.date == rhs.date
    }
}

struct ChatListModel: Decodable {
    let chats: [ChatModel]
}


struct ChatModelExtended: Identifiable, Equatable{
    let id: Int
    let title: String
    let date: String
    let comparableDate: Date
    
    init(chatModel: ChatModel){
        self.id = chatModel.id
        self.title = chatModel.title
        self.date = chatModel.date
        self.comparableDate = Date.getDate(date: chatModel.date)
    }
    
    static func ==(lhs: ChatModelExtended, rhs: ChatModelExtended) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.date == rhs.date
    }
}
