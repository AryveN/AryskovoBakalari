//
//  TimetableNavbar.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 27.02.2024.
//

import SwiftUI

struct TimetableNavbar: View {
    @Binding var presentSideMenu: Bool
    @State private var backToggle: Bool = false
    @State private var refreshToggle: Bool = false
    @State private var showingAlert = false
    @State private var redirectLogin = false
    @Environment(\.colorScheme) var colorScheme
    let days = getDaysResponseFromUserDefaults()
    
    var body: some View {
        HStack(alignment: .center, spacing: 275) {
            Button {
                backToggle.toggle()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(colorScheme == .dark ? Color(red: 97, green: 97, blue: 97) : .white)
                    .frame(width: 36, height: 36)
            }
            Button {
                let token = getTokenResponseFromUserDefaults()
                
                var transaction = Transaction()
                transaction.disablesAnimations = true
                
                if (token != nil) {
                    timetableRequest(date: Date(), accessToken: token!.accessToken) { success in
                        if success {
                            print("Getting TimeTable successful")
                            withTransaction(transaction) {
                                refreshToggle.toggle()
                            }
                        } else {
                            print("Getting TimeTable failed")
                        }
                    }
                } else {
                    self.showingAlert.toggle()
                }
            } label: {
                Image(systemName: "arrow.2.circlepath")
                    .foregroundColor(colorScheme == .dark ? Color(red: 97, green: 97, blue: 97) : .white)
                    .frame(width: 36, height: 36)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Log In Required"), message: Text("You need to log in to access this feature."), primaryButton: .destructive(Text("Log In")) {
                    self.redirectLogin.toggle()
                }, secondaryButton: .cancel())
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 50)
        .padding(.vertical, 9)
        .frame(width: 393, height: 110, alignment: .top)
        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
        .fullScreenCover(isPresented: $backToggle) {
            MainScreen(logout: Binding.constant(false), colorScheme: Environment(\.colorScheme).self, presentSideMenu: Binding.constant(false))
        }
        .fullScreenCover(isPresented: $refreshToggle) {
            TimetableView(presentSideMenu: Binding.constant(false), colorScheme: Environment(\.colorScheme).self)
        }
        .transition(.slide)
    }
}
