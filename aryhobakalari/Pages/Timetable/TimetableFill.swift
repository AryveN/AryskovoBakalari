//
//  TimetableFill.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 27.02.2024.
//

import SwiftUI

struct TimetableFill: View {
    @Binding var presentSideMenu: Bool
    @State private var backToggle: Bool = false
    @State private var showingAlert = false
    @State private var redirectLogin = false
    @Environment(\.colorScheme) var colorScheme
    let days = try getDaysResponseFromUserDefaults()
    
    var body: some View {
        VStack {
            // Days and TimeTable
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack {}
                        .frame(width: UIScreen.main.bounds.width * 0.20, height: 42)
                        .background(Color(red: 0.25, green: 0.25, blue: 0.25))
                    
                    GeometryReader { geometry in
                        VStack (spacing: 0) {
                            VStack {
                                Text("Po")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.purple)
                                Text(formatDateRange(days?.Days[0].Date ?? "xy") ?? "xy")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                                .frame(width: geometry.size.width, height: calculateHeight(geometry: geometry))
                                .background(Color(red: 0.38, green: 0.38, blue: 0.38))
                                .overlay(
                                    Rectangle()
                                        .inset(by: -0.5)
                                        .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 2)
                                    )
                            
                            VStack {
                                Text("Út")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.purple)
                                Text(formatDateRange(days?.Days[1].Date ?? "xy") ?? "xy")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                                .frame(width: geometry.size.width, height: calculateHeight(geometry: geometry))
                                .background(Color(red: 0.25, green: 0.25, blue: 0.25))
                                .overlay(
                                    Rectangle()
                                        .inset(by: -0.5)
                                        .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 2)
                                    )
                            
                            VStack {
                                Text("St")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.purple)
                                Text(formatDateRange(days?.Days[2].Date ?? "xy") ?? "xy")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                                .frame(width: geometry.size.width, height: calculateHeight(geometry: geometry))
                                .background(Color(red: 0.38, green: 0.38, blue: 0.38))
                                .overlay(
                                    Rectangle()
                                        .inset(by: -0.5)
                                        .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 2)
                                    )
                            
                            VStack {
                                Text("Čt")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.purple)
                                Text(formatDateRange(days?.Days[3].Date ?? "xy") ?? "xy")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                                .frame(width: geometry.size.width, height: calculateHeight(geometry: geometry))
                                .background(Color(red: 0.25, green: 0.25, blue: 0.25))
                                .overlay(
                                    Rectangle()
                                        .inset(by: -0.5)
                                        .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 2)
                                    )
                            
                            VStack {
                                Text("Pá")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.purple)
                                Text(formatDateRange(days?.Days[4].Date ?? "xy") ?? "xy")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .frame(width: geometry.size.width, height: calculateHeight(geometry: geometry))
                            .background(Color(red: 0.38, green: 0.38, blue: 0.38))
                            .overlay(
                                Rectangle()
                                    .inset(by: -0.5)
                                    .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 2)
                                )
                                
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.20, height: UIScreen.main.bounds.height - 95)
                
                // TimeTable
                ScrollView(.horizontal) {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        // Lesson Times
                        TimetableHours(presentSideMenu: Binding.constant(false), colorScheme: Environment(\.colorScheme).self)
                        
                        // Lessons
                        TimetableLessons(presentSideMenu: Binding.constant(false), colorScheme: Environment(\.colorScheme).self)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.80, height: UIScreen.main.bounds.height - 95) // Adjust height as needed
            }
        }
    }
}
