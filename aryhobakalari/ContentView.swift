//
//  ContentView.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 09.09.2022.
//
//

import SwiftUI

struct ContentView: View {
    
    @State private var loginView = false
    @Environment(\.colorScheme) var colorScheme
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    
    var body: some View {
        return Group {
            NavigationView {
                VStack(alignment: .center, spacing: 100) {
                    VStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 240, height: 240)
                            .background(
                                Image("uwuzvrh")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 240, height: 240)
                                    .clipped()
                            )
                        NameAuthor()
                    }
                    Spacer()
                        .frame(height: 30)
                    Button("Přihlásit se") {
                        loginView.toggle()
                    }
                    .font(Font.custom("Inter", size: 20))
                    .foregroundColor(.white)
                    .padding(10)
                    .frame(width: 144, height: 49, alignment: .center)
                    .background(Color(red: 0.98, green: 0.52, blue: 0.99))
                    .cornerRadius(25)
                    .fullScreenCover(isPresented: $loginView) {
                        //MainScreen(logout: Binding.constant(false), presentSideMenu: Binding.constant(true))
                        //TimetableView(presentSideMenu: Binding.constant(true))
                        // Mainly use -> 
                        LoginScreen()
                    }
                }
                .padding(.horizontal, 71)
                .padding(.vertical, 176)
                .frame(width: 393, height: 852, alignment: .center)
                .background(colorScheme == .dark ? Color(red: 0.07, green: 0.07, blue: 0.07) : .white)
            }
        }
    }
    
struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
