//
//  NoteRowView.swift
//  Proposer
//
//  Created by Artem Shuneyko on 11.04.23.
//

import SwiftUI

struct NoteRowView: View {
    @State private var isShowingBottomSheet = false
    @State var note: NoteModel
    @EnvironmentObject var notesVM: NotesViewModel

    var body: some View {
        Text(note.text)
            .font(Font.custom(Constants.notoSans, size: Constants.h2TextSize))
            .lineLimit(3)
            .truncationMode(.tail)
            .padding(.vertical, 16)
            .onTapGesture {
                isShowingBottomSheet = true
            }
            .sheet(isPresented: $isShowingBottomSheet) {
                EditNoteView(isShowing: self.$isShowingBottomSheet, model: note).environmentObject(notesVM)
            }
    }
}

struct NoteRowView_Previews: PreviewProvider {
    static var previews: some View {
        NoteRowView(note: NoteModel(id: 1, title: "", text: "123")).environmentObject(NotesViewModel())
    }
}
