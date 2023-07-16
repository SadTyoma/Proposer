//
//  NotesView.swift
//  Proposer
//
//  Created by Artem Shuneyko on 7.04.23.
//

import SwiftUI

struct NotesView: View {
    @State private var showAlert = false
    @State var selectedNote: NoteModel?
    @EnvironmentObject var notesVM: NotesViewModel
    @State var note = ""
    
    var body: some View {
        VStack {
            VStack{
                Text("Add note below")
                    .foregroundColor(.grayText2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $note)
                        .frame(height: 90)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(Constants.cornerRadius)
                        .padding(.horizontal, 16)
                    if note.isEmpty {
                        Text("Enter note text here")
                            .foregroundColor(.grayText)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                    }
                }
                
                Button(action: {
                    notesVM.saveNote(note)
                    note = ""
                }) {
                    Text("Add new note")
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
                ForEach(notesVM.notes, id: \.id) { note in
                    HStack {
                        NoteRowView(note: note).environmentObject(notesVM)
                    }
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button {
                            self.askToDelete(note)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(action: {
                            self.askToDelete(note)
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
                title: Text("Are you sure you want to delete this note?")
                    .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize)),
                message: Text("It will be deleted forever. It will not be used in message or chat generations.")
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
                        notesVM.deleteNote(selectedNote!)
                    }
            )
        }
        
    }
    
    func askToDelete(_ note: NoteModel){
        selectedNote = note
        showAlert = true
    }
}

struct NotesView_Previews: PreviewProvider {
    static let notesVM: NotesViewModel = {
        let nVM = NotesViewModel()
        nVM.notes = notesPreviewData
        
        return nVM
    }()
    
    static var previews: some View {
        NotesView(selectedNote: NoteModel(id: 1, title: "", text: "123")).environmentObject(notesVM)
    }
}
