//
//  LoginButton.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 13.09.2022.
//

import SwiftUI

struct LoginButton: View {
    var body: some View {
        Button("Přihlásit se") {
        }
        .padding()
        .border(colorScheme == .dark ? Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.5) : Color(red: 0.949, green: 0.714, blue: 0.984), width: 3)
        .background(Color(red: 0.983, green: 0.531, blue: 1.0))
        .foregroundColor(.black)
    }
}

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton()
    }
}
