//
//  ImageLoader.swift
//  Proposer
//
//  Created by Artem Shuneyko on 14.04.23.
//

import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: Image?
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        if let uiImage = UIImage(data: data){
                            self.image = Image(uiImage: uiImage)
                        }
                    }
                }
            }
        }.resume()
    }
}
