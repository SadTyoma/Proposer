//
//  LinkView.swift
//  Proposer
//
//  Created by Artem Shuneyko on 7.04.23.
//

import SwiftUI

struct LinksView: View {
    @State private var showAlert = false
    @State private var selectedIndex = 0
    @EnvironmentObject var linksVM: LinksViewModel
    @State var link = ""
    
    var body: some View {
        VStack {
            VStack{
                Text("Add link below")
                    .foregroundColor(.grayText2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                
                TextField("", text: $link){
                    UIApplication.shared.endEditing()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(Color.white)
                .foregroundColor(Color.black)
                .cornerRadius(Constants.cornerRadius)
                .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                .overlay(
                    Text("Enter link here")
                        .foregroundColor(.grayText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .opacity(link.isEmpty ? 1 : 0)
                )
                .padding(.horizontal, 16)
                
                Button(action: {
                    linksVM.saveLink(link)
                    link = ""
                }) {
                    Text("Add new link")
                        .foregroundColor(.whiteText)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.background)
                        .cornerRadius(Constants.cornerRadius)
                        .font(Font.custom(Constants.notoSans, size: Constants.h2TextSize))
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            
            List {
                ForEach(linksVM.links.indices, id: \.self) { index in
                    HStack {
                        ImageView(url: linksVM.links[index].faviconUrl)
                        
                        Text(linksVM.links[index].linkTitle)
                            .font(Font.custom(Constants.notoSans, size: Constants.h2TextSize))
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button {
                            self.askToDelete(at: index)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(action: {
                            self.askToDelete(at: index)
                        }) {
                            Image(systemName: "xmark")
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
        }
        .background(Color.grayBackground)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure you want to delete this link?")
                    .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize)),
                message: Text("Link \(linksVM.links[selectedIndex].linkTitle) will be deleted forever. It will not be used in message or chat generations.")
                    .font(Font.custom(Constants.notoSans, size: Constants.h3TextSize)),
                primaryButton:
                        .default(Text("Cancel")
                            .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                            .foregroundColor(.purpleText)) {
                                // Handle Cancel button tap here
                                showAlert = false
                            }
                ,
                secondaryButton: .destructive(Text("Delete")
                    .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))) {
                        // Handle OK button tap here
                        showAlert = false
                        linksVM.deleteLink(at: selectedIndex)
                    }
            )
        }
    }
    
    func askToDelete(at index: Int){
        selectedIndex = index
        showAlert = true
    }
    
    func loadImage(_ strUrl: String, completion: @escaping (Image?) -> Void) {
        guard let url = URL(string: strUrl) else {
            completion(nil)
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func loadImage(_ strUrl: String) -> AnyView {
        guard let url = URL(string: strUrl) else {
            return AnyView(EmptyView())
        }
        
        let placeholderImage = Image(systemName: "globe")
            .resizable()
            .frame(width: 20, height: 20)
        
        @State var image = placeholderImage
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                image = Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }.resume()
        
        return AnyView(image)
    }
}

struct ImageView: View {
    @StateObject var imageLoader = ImageLoader()
    let url: String
    
    var body: some View {
        if let image = imageLoader.image {
            image
                .resizable()
                .frame(width: 20, height: 20)
        } else {
            Image(systemName: "globe")
                .resizable()
                .frame(width: 20, height: 20)
                .onAppear {
                    if let url = URL(string: url) {
                        imageLoader.loadImage(from: url)
                    }
                }
        }
    }
}

struct LinkView_Previews: PreviewProvider {
    static let linksVM: LinksViewModel = {
        let lVM = LinksViewModel()
        lVM.links = linksPreviewData
        
        return lVM
    }()
    
    static var previews: some View {
        LinksView().environmentObject(linksVM)
    }
}
