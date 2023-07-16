//
//  NotesViewModel.swift
//  Proposer
//
//  Created by Artem Shuneyko on 8.04.23.
//

import Foundation

final class NotesViewModel : ObservableObject{
    @Published var notes: [NoteModel] = []
    
    init(){
        getNotes()
    }
    
    func getNotes(){
        APIWrapper.shared.loadNotes { result in
            DispatchQueue.main.async {
                self.notes.removeAll()
                self.notes = result
            }
        }
    }
    
    func updateNotes(){
        APIWrapper.shared.loadNotes { result in
            DispatchQueue.main.async {
                let notesToAdd = result.filter { resultItem in
                    !self.notes.contains { noteItem in
                        noteItem.id == resultItem.id
                    }
                }
                notesToAdd.forEach { note in
                    self.notes.append(note)
                }
            }
        }
    }
    
    func saveNote(_ note: String){
        APIWrapper.shared.sendNoteToServer(title: "", text: note){result in
            switch result {
            case .success(let data):
                self.getNotes() //TODO: use update
                print(data)
            case .failure(let error):
                // Handle failure with the error
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteNote(_ note: NoteModel) {
        let noteId = note.id
        deleteNote(byId: noteId)
    }
    
    func deleteNote(byId noteId: Int){
        APIWrapper.shared.deleteNote(withId: noteId) { result in
            switch result {
            case .success:
//                DispatchQueue.main.async {
//                    self.notes.remove(at: index)
//                }
                self.getNotes() //TODO: remove this
                print("Link deleted successfully")
            case .failure(let error):
                print("Error deleting link: \(error.localizedDescription)")
            }
        }
    }
    
    func updateNote(model: NoteModel){
        let oldId = model.id
        let newText = model.text
        deleteNote(byId: oldId)
        saveNote(newText)
    }
}
