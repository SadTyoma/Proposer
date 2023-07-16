//
//  Extensions.swift
//  Proposer
//
//  Created by Artem Shuneyko on 6.04.23.
//

import Foundation
import SwiftUI

extension Color{
    static let background = Color("Background")
    static let lightBackground = Color("LightBackground")
    static let whiteText = Color("WhiteText")
    static let purpleText = Color("PurpleText")
    static let grayText2 = Color("GrayText2")
    static let grayBackground = Color("GrayBackground")
    static let grayText = Color("GrayText")
    static let micColor = Color("MicColor")
    static let blackText = Color("BlackText")
}

extension Date {
    var day: String {
        let dateFormatter = DateFormatter()
        if Calendar.current.isDateInToday(self) {
            dateFormatter.dateFormat = "'Today', d MMMM"
        } else if Calendar.current.isDateInYesterday(self) {
            dateFormatter.dateFormat = "'Yesterday', d MMMM"
        } else {
            dateFormatter.dateFormat = "d MMMM"
        }
        return dateFormatter.string(from: self)
    }
    
    static func getDate(date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        let resultDate = dateFormatter.date(from: date) ?? Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: resultDate)
        return calendar.date(from: components)!
    }
}


extension View {
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

extension Color {
    func toUIColor() -> UIColor {
        let components = self.components()
        return UIColor(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
    }
    
    private func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
