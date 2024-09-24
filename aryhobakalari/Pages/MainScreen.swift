//
//  MainScreen.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 13.09.2022.
//

import SwiftUI
struct MainScreen: View {
    @Binding var logout: Bool
    @State private var logoutToggle: Bool = false
    @State private var timetableToggle: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State private var showingAlert = false
    @State private var redirectLogin = false
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        VStack {
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
                    Text("Beta")
                        .font(.subheadline)
                    Text("Rozvrh only")
                        .font(.caption)
                }
                
                VStack(alignment: .center, spacing: 20) {
                    HStack(alignment: .center, spacing: 10) {
                        Button("Rozvrh") {
                            let token = getTokenResponseFromUserDefaults()
                            if (token != nil) {
                                timetableRequest(date: Date(),accessToken: token!.accessToken) { success in
                                    if success {
                                        print("Getting TimeTable successful")
                                        timetableToggle.toggle()
                                    } else {
                                        print("Getting TimeTable failed")
                                        self.showingAlert.toggle()
                                    }
                                }
                            } else {
                                self.showingAlert.toggle()
                            }
                        }
                          .font(Font.custom("Inter", size: 20))
                          .foregroundColor(.white)
                    }
                    .padding(10)
                    .frame(width: 144, height: 49, alignment: .center)
                    .background(Color(red: 0.98, green: 0.52, blue: 0.99))
                    .cornerRadius(25)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Log In Required"), message: Text("You need to log in to access this feature."), primaryButton: .destructive(Text("Log In")) {
                            self.redirectLogin.toggle()
                        }, secondaryButton: .cancel())
                    }
                    
                    HStack(alignment: .center, spacing: 10) {
                        Button("Odhlásit se") {
                            logout.toggle()
                            logoutToggle.toggle()
                        }
                          .font(Font.custom("Inter", size: 20))
                          .foregroundColor(.white)
                    }
                    .padding(10)
                    .frame(width: 144, height: 49, alignment: .center)
                    .background(Color(red: 0.98, green: 0.52, blue: 0.99))
                    .cornerRadius(25)
                }
                .padding(.horizontal, 54)
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .fullScreenCover(isPresented: $logoutToggle) {
                ContentView();
            }
            .fullScreenCover(isPresented: $timetableToggle) {
                TimetableView(presentSideMenu: Binding.constant(true), selectedTimetable: 1);
            }
            .fullScreenCover(isPresented: $redirectLogin) {
                LoginScreen()
            }
            .padding(.horizontal, 71)
            .padding(.vertical, 176)
            .frame(width: 393, height: 852, alignment: .center)
            .background(colorScheme == .dark ? Color(red: 0.07, green: 0.07, blue: 0.07) : .white)
        }
    }
}

/*struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}*/
