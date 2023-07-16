//
//  LinksViewModel.swift
//  Proposer
//
//  Created by Artem Shuneyko on 8.04.23.
//

import Foundation

final class LinksViewModel : ObservableObject{
    @Published var links: [LinkModel] = []
    
    init(){
        getLinks()
    }
    
    func getLinks(){
        APIWrapper.shared.loadLinks { result in
            DispatchQueue.main.async {
                self.links.removeAll()
                self.links = result
            }
        }
    }
    
    func updateLinks(){
        APIWrapper.shared.loadLinks { result in
            DispatchQueue.main.async {
                let linksToAdd = result.filter { resultItem in
                    !self.links.contains { linkItem in
                        linkItem.id == resultItem.id
                    }
                }
                linksToAdd.forEach { link in
                    self.links.append(link)
                }
            }
        }
    }
    
    func saveLink(_ link: String){
        APIWrapper.shared.sendLinkToServer(link){result in
            switch result {
            case .success(let data):
                self.getLinks() //TODO: use update
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteLink(at index: Int) {
        let linkId = links[index].id
        APIWrapper.shared.deleteLink(withId: linkId) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.links.remove(at: index)
                }
                print("Link deleted successfully")
            case .failure(let error):
                print("Error deleting link: \(error.localizedDescription)")
            }
        }
    }
}
