//
//  ImportData.swift
//  Proposer
//
//  Created by Artem Shuneyko on 6.04.23.
//

import SwiftUI

struct ImportDataView: View {
    @State private var selectedSegment = 0
    @StateObject private var filesVM = FilesViewModel()
    @StateObject private var linksVM = LinksViewModel()
    @StateObject private var notesVM = NotesViewModel()
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Imported data")
                    .foregroundColor(.whiteText)
                    .font(Font.custom(Constants.notoSansBold, size: Constants.h1TextSize))
                    .lineSpacing(Constants.h1lineSpacing)
                    .kerning(Constants.h1kerning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                
                ZStack{
                    Color.grayBackground
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        Picker(selection: $selectedSegment, label: Text("")) {
                            Text("Files").tag(0)
                            Text("Links").tag(1)
                            Text("Notes").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 18)
                        .background(Color.grayBackground)
                        .onAppear{
                            UISegmentedControl.appearance().selectedSegmentTintColor = Color.background.toUIColor()
                                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
                            UISegmentedControl.appearance().backgroundColor = .white
                        }
                        
                        switch selectedSegment {
                        case 0:
                            FilesView().environmentObject(filesVM)
                        case 1:
                            LinksView().environmentObject(linksVM)
                        case 2:
                            NotesView(selectedNote: nil).environmentObject(notesVM)
                        default:
                            EmptyView()
                        }
                    }
                }
                
                
            }
        }
    }
}

struct ImportData_Previews: PreviewProvider {
    static var previews: some View {
        ImportDataView()
    }
}
