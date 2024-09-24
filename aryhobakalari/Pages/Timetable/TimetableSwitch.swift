//
//  TimetableSwitch.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 27.02.2024.
//

import SwiftUI

struct TimetableSwitch: View {
    @Binding var presentSideMenu: Bool
    @State var selectedTimetable: Int
    @State private var backToggle: Bool = false
    @State private var showingAlert = false
    @State private var redirectLogin = false
    @Environment(\.colorScheme) var colorScheme
    let days = try getDaysResponseFromUserDefaults()
    @State private var refreshTimetable = false
    
    var body: some View {
        HStack{
            HStack(alignment: .bottom) {
                Button("Aktuální Rozvrh") {
                    
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    
                    timetableRequest(date: Date() ,accessToken: getTokenResponseFromUserDefaults()?.accessToken ?? "") { success in
                        if success {
                            print("Getting TimeTable successful")
                            withTransaction(transaction) {
                                refreshTimetable.toggle()
                            }
                        } else {
                            print("Getting TimeTable failed")
                        }
                    }
                    selectedTimetable = 1
                }
                .disabled(selectedTimetable == 1)
                .font(
                    Font.custom("Inter", size: 16)
                        .weight(.black)
                )
                .foregroundColor(.white)
            }
            .padding(.vertical, 0)
            .frame(width: UIScreen.main.bounds.width/2, height: 40)
            
            HStack(alignment: .bottom) {
                Button("Stálý Rozvrh") {
                    
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    
                    timetablePermanentRequest(accessToken: getTokenResponseFromUserDefaults()?.accessToken ?? "") { success in
                        if success {
                            print("Getting TimeTable successful")
                            withTransaction(transaction) {
                                refreshTimetable.toggle()
                            }
                        } else {
                            print("Getting TimeTable failed")
                        }
                    }
                    selectedTimetable = 2
                }
                .disabled(selectedTimetable == 2)
                .font(
                    Font.custom("Inter", size: 16)
                        .weight(.black)
                )
                .foregroundColor(.white)
            }
            .frame(width: UIScreen.main.bounds.width/2, height: 40)
            
        }
        .frame(width: 393, height: 45)
        .background(Color(red: 0.25, green: 0.25, blue: 0.25))
        
        HStack {
            if selectedTimetable == 1 {
                ZStack {}
                    .frame(width: 196.5, height: 5)
                    .background(Color(red: 0.98, green: 0.52, blue: 0.99))
            } else {
                ZStack {}
                    .frame(width: 196.5, height: 5)
            }
            
            if selectedTimetable == 2 {
                ZStack {}
                    .frame(width: 196.5, height: 5)
                    .background(Color(red: 0.98, green: 0.52, blue: 0.99))
            } else {
                ZStack {}
                    .frame(width: 196.5, height: 5)
            }
        }
        .id(selectedTimetable)
        .frame(width: 393, height: 5)
        .fullScreenCover(isPresented: $refreshTimetable) {
            TimetableView(presentSideMenu: Binding.constant(false), selectedTimetable: selectedTimetable)
        }
    }
}
