//
//  FileModel.swift
//  Proposer
//
//  Created by Artem Shuneyko on 7.04.23.
//

import Foundation

struct FileModel: Identifiable, Decodable, Equatable {
    let id: Int
    let documentName: String
    var documentSize: Double
    var stringSize: String {
        return ByteCountFormatter.string(fromByteCount: Int64(documentSize * 1000), countStyle: .file)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "document_id"
        case documentName = "document_name"
        case documentSize = "document_size"
    }
    
    static func ==(lhs: FileModel, rhs: FileModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.documentName == rhs.documentName &&
            lhs.documentSize == rhs.documentSize
    }
}

struct FileListModel: Decodable {
    var documents: [FileModel]
}
