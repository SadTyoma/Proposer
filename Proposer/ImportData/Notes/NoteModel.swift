//
//  NoteModel.swift
//  Proposer
//
//  Created by Artem Shuneyko on 7.04.23.
//

import Foundation

struct NoteModel: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    var text: String
    
    enum CodingKeys: String, CodingKey {
        case id = "snippet_id"
        case title = "title"
        case text = "text"
    }
    
    static func ==(lhs: NoteModel, rhs: NoteModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.text == rhs.text
    }
}

struct NoteListModel: Decodable {
    let snippets: [NoteModel]
}

