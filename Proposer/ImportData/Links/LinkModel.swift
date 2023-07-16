//
//  LinkModel.swift
//  Proposer
//
//  Created by Artem Shuneyko on 7.04.23.
//

import Foundation

struct LinkModel: Identifiable, Decodable, Equatable {
    let id: Int
    let linkTitle: String
    let faviconUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "link_id"
        case linkTitle = "link_title"
        case faviconUrl = "favicon_url"
    }
    
    static func ==(lhs: LinkModel, rhs: LinkModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.linkTitle == rhs.linkTitle &&
            lhs.faviconUrl == rhs.faviconUrl
    }
}

struct LinkListModel: Decodable {
    let links: [LinkModel]
}
