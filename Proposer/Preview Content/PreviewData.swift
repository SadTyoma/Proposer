//
//  PreviewData.swift
//  Proposer
//
//  Created by Artem Shuneyko on 8.04.23.
//

import Foundation
import UIKit

let f1 = FileModel(id: 1, documentName: "sdsadasd", documentSize: 12)
let f2 = FileModel(id: 2, documentName: "123", documentSize: 2)
var filesPreviewData = [f1,f2]


let l1 = LinkModel(id: 1, linkTitle: "wewqeqwewqeqw", faviconUrl: "https://en.wikipedia.org/wiki/Favicon.ico")
let l2 = LinkModel(id: 2, linkTitle: "21321312", faviconUrl: "https://en.wikipedia.org/wiki/Favicon.ico")
var linksPreviewData = [l1,l2]


let n1 = NoteModel(id: 1, title: "", text: "Fixtender provides an integrated platform for easier contract management. It helps construction companies to keep track of all the paperwork..")
let n2 = NoteModel(id: 2, title: "", text: "Fixtender provides an integrated platform for easier contract management. It helps construction companies to keep track of all the paperwork..")
var notesPreviewData = [n1,n2]


let calendar = Calendar.current
let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
let c1 = ChatModel(id: 1, title: "Write me a cold email for investor. Add mrr plan from 2023 and 2024", date: "2023-04-08T13:59:49.265187")
let c2 = ChatModel(id: 2, title: "Write me a cold email for investor. Add mrr plan from 2023 and 2024", date: "2023-04-07T13:59:49.265187")
let c3 = ChatModel(id: 3, title: "Create a table to compare Foundry with Proposer with features as rows", date: "2023-04-07T13:59:49.265187")
let c4 = ChatModel(id: 4, title: "Write me a cold email for investor. Add mrr plan from 2023 and 2024", date: "2023-04-06T13:59:49.265187")
let c5 = ChatModel(id: 5, title: "Write me a cold email for investor. Add mrr plan from 2023 and 2024", date: "2023-04-04T13:59:49.265187")

let lastChatsPreviewData = [ChatModelExtended(chatModel: c1),ChatModelExtended(chatModel: c2),ChatModelExtended(chatModel: c3),ChatModelExtended(chatModel: c4),ChatModelExtended(chatModel: c5)]
