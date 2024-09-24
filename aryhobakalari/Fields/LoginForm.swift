//
//  LoginForm.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 10.09.2022.
//

import SwiftUI
import UIKit

struct LoginForm: View{
    
    @State private var username: String
    @State private var password: String
    @State private var login: Bool = false
    @State private var error: Bool = false
    @State private var isLoading: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        return Group {
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
                
                VStack(alignment: .center, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        TextField(
                            "Uživatelské jméno",
                            text: $username
                        )
                        .font(Font.custom("Inter", size: 16))
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                    }
                    .padding(.leading, 10)
                    .padding(.vertical, 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(Color(red: 0.66, green: 0.66, blue: 0.66))
                    .cornerRadius(50)
                    
                    HStack(alignment: .center, spacing: 10) {
                        SecureField(
                            "Heslo",
                            text: $password
                        )
                        .font(Font.custom("Inter", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .padding(.leading, 10)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(Color(red: 0.66, green: 0.66, blue: 0.66))
                    .cornerRadius(50)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    
                    Button("Přihlásit se") {
                        isLoading.toggle()
                        firstLogin(username: username, password: password) {success in
                            if success {
                                print("Login successful")
                                login = true
                                isLoading.toggle()
                                
                                let scheduler = NotificationScheduler()
                                scheduler.scheduleNotifications()
                            } else {
                                print("Login failed")
                                self.error.toggle()
                                isLoading.toggle()
                            }
                        }
                    }
                    .disabled(isLoading)
                    .font(Font.custom("Inter", size: 20))
                    .foregroundColor(.white)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(Color(red: 0.98, green: 0.52, blue: 0.99))
                    .cornerRadius(25)
                }
                .padding(10)
                .frame(maxWidth: .infinity, minHeight: 169, maxHeight: 169, alignment: .center)
                .background(Color(red: 0.38, green: 0.38, blue: 0.38))
                .cornerRadius(25)

                if isLoading {
                    ProgressView("Přihlašování...")
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 176)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            .background(colorScheme == .dark ? Color(red: 0.07, green: 0.07, blue: 0.07) : .white)
            .alert(isPresented: $error) {
                Alert(title: Text("Login failed"), message: Text("An error occurred while logging in."), primaryButton: .default(Text("Try again")) {
                    firstLogin(username: username, password: password) { success in
                        if success {
                            print("Login successful")
                            login = true
                            isLoading.toggle()
                        } else {
                            print("Login failed")
                            error = true
                            isLoading.toggle()
                            self.error.toggle()
                        }
                    }
                }, secondaryButton: .destructive(Text("Cancel")))
            }
            .fullScreenCover(isPresented: $login) {
                MainTabbed()
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginForm()
    }
}
