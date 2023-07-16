//
//  FileViewModel.swift
//  Proposer
//
//  Created by Artem Shuneyko on 8.04.23.
//

import Foundation

final class FilesViewModel : ObservableObject{
    @Published var files: [FileModel] = []
    @Published var loadingFiles: [Bool] = []
    
    init(){
        getFiles()
    }
    
    func getFiles(){
        APIWrapper.shared.loadFiles { result in
            DispatchQueue.main.async {
                self.files.removeAll()
                self.loadingFiles.removeAll()
                
                self.files = result
                self.loadingFiles = Array(repeating: false, count: result.count)
            }
        }
    }
    
    func updateFiles(){
        APIWrapper.shared.loadFiles { result in
            DispatchQueue.main.async {
                let filesToDelete = self.files.filter{$0.id == -1}
                filesToDelete.forEach { file in
                    let index = self.files.firstIndex(of: file)!
                    self.files.remove(at: index)
                    self.loadingFiles.remove(at: index)
                }
                
                let filesToAdd = result.filter { resultItem in
                    !self.files.contains { fileItem in
                        fileItem.id == resultItem.id
                    }
                }
                filesToAdd.forEach { file in
                    self.files.append(file)
                    self.loadingFiles.append(false)
                }
            }
        }
    }
    
    func saveFile(_ selectedFile: URL) throws{
        let attributes = try FileManager.default.attributesOfItem(atPath: selectedFile.path)
        let fileSize = attributes[.size] as! Double
        
        files.append(FileModel(id: -1, documentName: selectedFile.lastPathComponent, documentSize: fileSize / 1000))
        loadingFiles.append(true)
        
        let fileData = try Data(contentsOf: selectedFile)
        let pathExt = selectedFile.pathExtension
        APIWrapper.shared.sendFileToServer(fileData, fileName: selectedFile.lastPathComponent, fileExtension: pathExt) { result in
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8)!)
                self.getFiles() //TODO: use update
            case .failure(let error):
                DispatchQueue.main.async {
                    self.files.removeLast()
                    self.loadingFiles.removeLast()
                    print("Error saving document: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteFile(at index: Int) {
        let fileId = files[index].id
        APIWrapper.shared.deleteDocument(withId: fileId) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.files.remove(at: index)
                }
                print("Document deleted successfully")
            case .failure(let error):
                print("Error deleting document: \(error.localizedDescription)")
            }
        }
    }
}
