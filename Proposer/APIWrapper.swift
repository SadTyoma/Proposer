//
//  APIWrapper.swift
//  Proposer
//
//  Created by Artem Shuneyko on 8.04.23.
//

import Foundation
import MobileCoreServices

final class APIWrapper{
    private init(){
        if let path = Bundle.main.path(forResource: "PrivateData", ofType: "plist") {
            let keys = NSDictionary(contentsOfFile: path)!
            baseUrl = keys["baseUrl"] as! String
        }
    }
    
    static var shared: APIWrapper = {
        let instance = APIWrapper()
        return instance
    }()
    
    private var baseUrl = ""
    
    private var userCheckUrl: String {
        get{
            return "\(baseUrl)/v1/user/check/"
        }
    }
    
    private var chatListUrl: String {
        get{
            return "\(baseUrl)/v1/getters/assistant_chat_list/"
        }
    }
    
    private var chatByIdUrl: String {
        get{
            return "\(baseUrl)/v1/getters/assistant_chat/"
        }
    }
    private var deleteChatByIdUrl: String {
        get{
            return "\(baseUrl)/v1/deleters/chat/"
        }
    }
    
    private var sendMessageUrl: String {
        get{
            return "\(baseUrl)/v1/assistant/question/"
        }
    }
    
    private var editMessageUrl: String {
        get{
            return "\(baseUrl)/v1/assistant/rewrite/"
        }
    }
    
    private var sendFileUrl: String {
        get {
            return "\(baseUrl)/v1/upload/document/"
        }
    }
    private var getFilesUrl: String {
        get {
            return "\(baseUrl)/v1/getters/document_list/"
        }
    }
    private var deleteFilesUrl: String {
        get {
            return "\(baseUrl)/v1/deleters/document/"
        }
    }
    
    private var sendLinkUrl: String {
        get {
            return "\(baseUrl)/v1/upload/link/"
        }
    }
    private var getLinksUrl: String {
        get {
            return "\(baseUrl)/v1/getters/link_list/"
        }
    }
    private var deleteLinkUrl: String {
        get {
            return "\(baseUrl)/v1/deleters/link/"
        }
    }
    
    private var sendNodeUrl: String{
        get{
            return "\(baseUrl)/v1/upload/snippet/"
        }
    }
    private var getNodesUrl: String{
        get{
            return "\(baseUrl)/v1/getters/snippet_list/"
        }
    }
    private var deleteNoteUrl: String {
        get {
            return "\(baseUrl)/v1/deleters/snippet/"
        }
    }
    
    public var tocken = ""
    
    func checkTockenRequest(_ tocken: String, completion: @escaping (Result<String, Error>) -> Void){
        guard let url = URL(string: userCheckUrl) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            // check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let message = result?["message"] as? String ?? ""
                
                self.tocken = tocken
                completion(.success(message))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func loadChats(completion: @escaping ([ChatModelExtended]) -> Void) {
        let url = URL(string: chatListUrl)!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion([])
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response.")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let chatListModel = try decoder.decode(ChatListModel.self, from: data)
                let updatedChats = chatListModel.chats.map { chat in
                    return ChatModelExtended(chatModel: chat)
                }
                completion(updatedChats)
            } catch {
                print(error)
                completion([])
            }
        }.resume()
    }
    
    func loadMessages(id: Int, completion: @escaping ([MessageModel]) -> Void) {
        let url = URL(string: "\(chatByIdUrl)\(id)")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion([])
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response.")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                var messages = try decoder.decode([MessageModel].self, from: data)
                for i in 0..<messages.count {
                    var message = messages[i]
                    self.formatMessage(&message.message)
                    messages[i] = message
                }
                
                completion(messages)
            } catch {
                print(error)
                completion([])
            }
        }.resume()
    }
    
    func sendMessage(_ text: String, toChat chatID: Int, completion: @escaping (String) -> Void, finishCompletion: @escaping (Bool) -> Void) {
        guard let url = URL(string: sendMessageUrl) else {
            print("Invalid URL")
            completion("")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "text": text,
            "chat_id": chatID
        ] as [String : Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print(error)
            completion("")
            return
        }
        
        let session = URLSession(configuration: .default, delegate: SSEDataTaskDelegate(completion: { result in
            var mutableResult = result
            self.formatMessage(&mutableResult)
            completion(mutableResult)
        }, finishCompletion: finishCompletion), delegateQueue: nil)
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    func rewriteMessage(messageId: Int, completion: @escaping (String) -> Void){
        guard let url = URL(string: "\(editMessageUrl)\(messageId)") else {
            print("Invalid URL")
            completion("")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion("")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response.")
                completion("")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion("")
                return
            }
            
            guard var message = String(data: data, encoding: .utf8) else {
                completion("")
                return
            }
            
            self.formatMessage(&message)
            
            completion(message)
        }.resume()
    }
    
    func deleteChat(withId id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        deleteData(url: deleteChatByIdUrl, id: id) { result in
            completion(result)
        }
    }
    
    private func mimeType(forFileExtension fileExtension: String) -> String? {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)?.takeRetainedValue() {
            if let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimeType as String
            }
        }
        return nil
    }
    
    func sendFileToServer(_ data: Data, fileName: String, fileExtension: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: sendFileUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let mimeType = mimeType(forFileExtension: fileExtension)
        
        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType!)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body as Data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 422 {
                    do {
                        let errorDetails = try JSONDecoder().decode(ErrorDetails422.self, from: data)
                        errorDetails.detail.forEach { detail in
                            print(detail.msg)
                        }
                        completion(.failure(NSError(domain: "Server Error", code: response.statusCode, userInfo: nil)))
                    } catch {
                        print("Unable to parse error details")
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                } else if response.statusCode == 200 {
                    completion(.success(data))
                } else {
                    completion(.failure(NSError(domain: "Server Error", code: response.statusCode, userInfo: nil)))
                }
            }
        }.resume()
    }
    
    
    func loadFiles(completion: @escaping ([FileModel]) -> Void) {
        guard let url = URL(string: getFilesUrl) else {
            print("Invalid URL")
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion([])
            } else if let data = data, let response = response as? HTTPURLResponse{
                if response.statusCode == 200 {
                    do {
                        let fileListModel = try JSONDecoder().decode(FileListModel.self, from: data)
                        DispatchQueue.main.async {
                            completion(fileListModel.documents)
                        }
                    } catch {
                        print("Unable to decode JSON data")
                        print(error.localizedDescription)
                        completion([])
                    }
                }
                else if response.statusCode == 422 {
                    do {
                        let errorDetails = try JSONDecoder().decode(ErrorDetails422.self, from: data)
                        errorDetails.detail.forEach { detail in
                            print(detail.msg)
                        }
                    } catch {
                        print("Unable to parse error details")
                        print(error.localizedDescription)
                    }
                } else{
                    print(data)
                }
                
            }
        }.resume()
    }
    
    func deleteDocument(withId id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        deleteData(url: deleteFilesUrl, id: id) { result in
            completion(result)
        }
    }
    
    func sendLinkToServer(_ link: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: link) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        guard var urlComponents = URLComponents(string: sendLinkUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "link_url", value: url.absoluteString)
        ]
        guard let requestURL = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                if (200..<300).contains(response.statusCode) {
                    completion(.success(data))
                } else if response.statusCode == 400 {
                    do {
                        let errorDetail = try JSONDecoder().decode(ErrorDetail400.self, from: data)
                        completion(.failure(NSError(domain: errorDetail.detail, code: response.statusCode, userInfo: nil)))
                    } catch {
                        completion(.failure(error))
                    }
                } else if response.statusCode == 422 {
                    do {
                        let errorDetails = try JSONDecoder().decode(ErrorDetails422.self, from: data)
                        let errors = errorDetails.detail.map { $0.msg }
                        completion(.failure(NSError(domain: errors.joined(separator: "\n"), code: response.statusCode, userInfo: nil)))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "Unexpected error", code: response.statusCode, userInfo: nil)))
                }
            }
        }.resume()
    }
    
    func loadLinks(completion: @escaping ([LinkModel]) -> Void) {
        guard let url = URL(string: getLinksUrl) else {
            print("Invalid URL")
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion([])
            } else if let data = data {
                do {
                    let linkListModel = try JSONDecoder().decode(LinkListModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(linkListModel.links)
                    }
                } catch {
                    print("Unable to decode JSON data")
                    print(error.localizedDescription)
                    completion([])
                }
            }
        }.resume()
    }
    
    func deleteLink(withId id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        deleteData(url: deleteLinkUrl, id: id) { result in
            completion(result)
        }
    }
    
    func sendNoteToServer(title: String, text: String, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: sendNodeUrl) else {
            completionHandler(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        let parameters = ["title": title, "text": text]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                if (200..<300).contains(response.statusCode) {
                    completionHandler(.success(data))
                } else if response.statusCode == 400 {
                    do {
                        let errorDetail = try JSONDecoder().decode(ErrorDetail400.self, from: data)
                        completionHandler(.failure(NSError(domain: errorDetail.detail, code: response.statusCode, userInfo: nil)))
                    } catch {
                        completionHandler(.failure(error))
                    }
                } else if response.statusCode == 422 {
                    do {
                        let errorDetails = try JSONDecoder().decode(ErrorDetails422.self, from: data)
                        let errors = errorDetails.detail.map { $0.msg }
                        completionHandler(.failure(NSError(domain: errors.joined(separator: "\n"), code: response.statusCode, userInfo: nil)))
                    } catch {
                        completionHandler(.failure(error))
                    }
                } else {
                    completionHandler(.failure(NSError(domain: "Unexpected error", code: response.statusCode, userInfo: nil)))
                }
            } else {
                completionHandler(.failure(NSError(domain: "No data in response", code: -1, userInfo: nil)))
            }
        }.resume()
    }
    
    func loadNotes(completionHandler: @escaping ([NoteModel]) -> Void) {
        guard let url = URL(string: getNodesUrl) else {
            completionHandler([])
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler([])
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                if (200..<300).contains(response.statusCode) {
                    do {
                        let noteListModel = try JSONDecoder().decode(NoteListModel.self, from: data)
                        completionHandler(noteListModel.snippets)
                    } catch {
                        completionHandler([])
                        
                    }
                } else if response.statusCode == 422 {
                    do {
                        let errorDetails = try JSONDecoder().decode(ErrorDetails422.self, from: data)
                        errorDetails.detail.forEach { detail in
                            print(detail.msg)
                        }
                    } catch {
                        print("Unable to parse error details")
                        print(error.localizedDescription)
                    }
                } else{
                    print(data)
                }
            } else {
                completionHandler([])
            }
        }.resume()
    }
    
    func deleteNote(withId id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        deleteData(url: deleteNoteUrl, id: id) { result in
            completion(result)
        }
    }
    
    private func formatMessage(_ message: inout String) {
        let formattedMessage = message.replacingOccurrences(of: "(\n|\\s)*<b>", with: " **", options: .regularExpression)
            .replacingOccurrences(of: "(\n|\\s)*</b>", with: "** ", options: .regularExpression)
        message = formattedMessage
    }
    
    private func deleteData(url: String, id: Int, completion: @escaping (Result<String, Error>) -> Void){
        if let url = URL(string: "\(url)\(id)") {
            var request = URLRequest(url: url)
            request.addValue("Bearer \(tocken)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 422 {
                        do {
                            let errorDetails = try JSONDecoder().decode(ErrorDetails422.self, from: data)
                            errorDetails.detail.forEach { detail in
                                print(detail.msg)
                            }
                            completion(.failure(NSError(domain: "Server Error", code: response.statusCode, userInfo: nil)))
                        } catch {
                            print("Unable to parse error details")
                            print(error.localizedDescription)
                            completion(.failure(error))
                        }
                    } else if response.statusCode == 200 {
                        completion(.success(String(data: data, encoding: .utf8)!))
                    } else {
                        completion(.failure(NSError(domain: "Server Error", code: response.statusCode, userInfo: nil)))
                    }
                }
            }.resume()
        }
    }
    
    private class SSEDataTaskDelegate: NSObject, URLSessionDataDelegate {
        let completion: (String) -> Void
        let finishCompletion: (Bool) -> Void
        private let queue = DispatchQueue(label: "parse-queue")
        private let group = DispatchGroup()
        
        init(completion: @escaping (String) -> Void, finishCompletion: @escaping (Bool) -> Void){
            self.completion = completion
            self.finishCompletion = finishCompletion
        }
        
        func parse(_ data: Data) {
            group.enter()
            if let message = String(data: data, encoding: .utf8) {
                let prefixLength = "data: data: ".count
                let jsonSubstring = message.dropFirst(prefixLength)
                let json = try? JSONSerialization.jsonObject(with: Data(jsonSubstring.utf8), options: []) as? [String: Any]
                if let text = json?["text"] as? String {
                    self.completion(text)
                }
            }
            group.leave()
        }
        
        
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            queue.async { [unowned self] in
                self.parse(data)
            }
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
            self.finishCompletion(true)
        }
    }
}
