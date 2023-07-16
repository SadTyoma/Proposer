//
//  ChatMessageModel.swift
//  Proposer
//
//  Created by Artem Shuneyko on 7.04.23.
//

import Foundation

struct MessageModel: Identifiable, Decodable, Equatable, Hashable {
    let id: Int
    let author: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case id = "message_id"
        case author
        case message
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(author)
        hasher.combine(message)
    }
    
    static func ==(lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.author == rhs.author &&
        lhs.message == rhs.message
    }
    
    func isUser() -> Bool{
        return author == "user"
    }
}

struct MessageListModel: Decodable {
  let messages: [MessageModel]
}
