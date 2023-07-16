//
//  Errors.swift
//  Proposer
//
//  Created by Artem Shuneyko on 8.04.23.
//

import Foundation

struct ErrorDetails422: Codable {
    let detail: [ErrorDetail422]
}

struct ErrorDetail422: Codable {
    let loc: [String]
    let msg: String
    let type: String
}

struct ErrorDetail400: Codable {
    let detail: String
}
