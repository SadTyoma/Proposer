//
//  FilesView.swift
//  Proposer
//
//  Created by Artem Shuneyko on 7.04.23.
//

import SwiftUI

struct FilesView: View {
    @State private var showAlert = false
    @State private var isImporting: Bool = false
    @State private var selectedIndex = 0
    @EnvironmentObject var filesVM: FilesViewModel
    
    var body: some View {
        VStack {
            Button(action: {
                isImporting = true
            }) {
                Text("Add new file")
                    .foregroundColor(.whiteText)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.background)
                    .cornerRadius(Constants.cornerRadius)
                    .font(Font.custom(Constants.notoSans, size: Constants.h2TextSize))
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [.item],
                allowsMultipleSelection: false
            ) { result in
                defer{
                    isImporting = false
                }
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    if selectedFile.startAccessingSecurityScopedResource() {
                        try filesVM.saveFile(selectedFile)
                    }
                    selectedFile.stopAccessingSecurityScopedResource()
                } catch {
                    print("Unable to read file contents")
                    print(error.localizedDescription)
                }
            }
            .padding(.horizontal, 16)
            
            List {
                ForEach(filesVM.files.indices, id: \.self) { index in
                    HStack {
                        Text(filesVM.files[index].documentName)
                            .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                        Spacer()
                        if filesVM.loadingFiles[index] {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        Text(String(filesVM.files[index].stringSize))
                            .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                            .foregroundColor(.grayText)
                            .padding(.leading, 12)
                    }
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button {
                            self.askToDelete(at: index)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(action: {
                            self.askToDelete(at: index)
                        }) {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure you want to delete this file?")
                    .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize)),
                message: Text("File “File with very long name that will blow your \(filesVM.files[selectedIndex].documentName)” will be deleted forever. It will not be used in message or chat generations.")
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
                        filesVM.deleteFile(at: selectedIndex)
                    }
            )
        }
    }
    
    func askToDelete(at index: Int){
        selectedIndex = index
        showAlert = true
    }
}

struct FilesView_Previews: PreviewProvider {
    static let filesVM: FilesViewModel = {
        let fVM = FilesViewModel()
        fVM.files = [FileModel(id: 1, documentName: "test", documentSize: 5000000)]
        fVM.loadingFiles = [false]
        
        return fVM
    }()
    
    static var previews: some View {
        FilesView().environmentObject(filesVM)
    }
}
