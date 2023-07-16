//
//  EditNoteView.swift
//  Proposer
//
//  Created by Artem Shuneyko on 7.04.23.
//

import SwiftUI

struct EditNoteView: View {
    @Binding var isShowing: Bool
    @State var model: NoteModel
    @EnvironmentObject var notesVM: NotesViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $model.text)
                    .font(Font.custom(Constants.notoSans, size: Constants.baseTextSize))
                    .padding(12)
                    .scrollContentBackground(.hidden)
                    .background(Color.grayBackground)

                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(y: isShowing ? 0 : UIScreen.main.bounds.height)
            .animation(.spring())
            .navigationBarTitle("Edit Note", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.isShowing = false
            }) {
                Text("Close")
                    .font(Font.custom(Constants.notoSans, size: Constants.h2TextSize))
                    .foregroundColor(.purpleText)
            }, trailing: Button(action: {
                notesVM.updateNote(model: model)
                self.isShowing = false
            }) {
                Text("Save note")
                    .font(Font.custom(Constants.notoSans, size: Constants.h2TextSize))
                    .foregroundColor(.purpleText)
            })
        }
    }
}

struct EditNoteView_Previews: PreviewProvider {
    static var previews: some View {
        EditNoteView(isShowing: .constant(true), model: NoteModel(id: 0, title: "", text: "Fixtender provides an integrated platform for easier contract management. It helps construction companies to keep track of all the paperwork and agreements associated with their projects. The platform offers a secure and centralized store of contracts and invoices, enabling easy access and management of the documents. Fixtender’s automated workflow helps to streamline the entire process. It automates the creation of construction-specific spreadsheets and offers easy comparison of offers between contractors and suppliers. It also helps to provide real-time profit and loss analytics, so you can keep track of your progress and avoid potential problems. Fixtender’s automated workflow helps to streamline the entire process. It automates the creation of construction-specific spreadsheets and offers easy comparison of offers between contractors and suppliers. It also helps to provide real-time profit and loss analytics, so you can keep track of your progress and avoid potential problems. Fixtender’s automated workflow helps to streamline the entire process. It automates the creation of construction-specific spreadsheets and offers easy comparison of offers between contractors and suppliers. It also helps to provide real-time profit and loss analytics, so you can keep track of your progress and avoid potential problems. Fixtender provides an integrated platform for easier contract management. It helps construction companies to keep track of all the paperwork and agreements associated with their projects. The platform offers a secure and centralized store of contracts and invoices, enabling easy access and management of the documents. Fixtender’s automated workflow helps to streamline the entire process. It automates the creation of construction-specific spreadsheets and offers easy comparison of offers between contractors and suppliers. It also helps to provide real-time profit and loss analytics, so you can keep track of your progress and avoid potential problems. Fixtender’s automated workflow helps to streamline the entire process. It automates the creation of construction-specific spreadsheets and offers easy comparison of offers between contractors and suppliers. It also helps to provide real-time profit and loss analytics, so you can keep track of your progress and avoid potential problems. Fixtender’s automated workflow helps to streamline the entire process. It automates the creation of construction-specific spreadsheets and offers easy comparison of offers between contractors and suppliers. It also helps to provide real-time profit and loss analytics, so you can keep track of your progress and avoid potential problems.")).environmentObject(NotesViewModel())
    }
}
