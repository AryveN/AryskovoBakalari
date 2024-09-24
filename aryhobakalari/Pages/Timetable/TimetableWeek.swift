// TimetableWeek.swift
// aryhobakalari

// Created by Krystof Hugo Maly on 27.02.2024.

import SwiftUI
import os

struct TimetableWeek: View {
    @Binding var presentSideMenu: Bool
    @State private var backToggle: Bool = false
    @State private var showingAlert = false
    @State private var redirectLogin = false
    @Environment(\.colorScheme) var colorScheme
    let days = try getDaysResponseFromUserDefaults()
    @State private var refreshTimetable = false
    @State private var selectedWeek = Date() // New state variable to store selected week

    var body: some View {
        VStack {
            let logger = Logger()
            HStack(alignment: .center, spacing: 40) {
                Button {
                    let previousWeek = selectedWeek - 604800 // Subtract interval for previous week
                    selectedWeek = previousWeek
                    timetableRequest(date: previousWeek, accessToken: getTokenResponseFromUserDefaults()?.accessToken ?? "") { success in
                        if success {
                            logger.info("Getting TimeTable for last week successful: \(previousWeek)")
                            withAnimation(nil) {
                                refreshTimetable.toggle()
                            }
                        } else {
                            logger.info("Getting TimeTable for last week failed: \(previousWeek)")
                        }
                    }
                } label: {
                    Image(systemName: "arrowtriangle.left.fill")
                        .frame(width: 48, height: 48)
                        .foregroundColor(.white)
                }

                Button {
                    selectedWeek = Date() // Set selectedWeek to current week
                    timetableRequest(date: selectedWeek, accessToken: getTokenResponseFromUserDefaults()?.accessToken ?? "") { success in
                        if success {
                            logger.info("Getting TimeTable for current week successful: \(selectedWeek)")
                            withAnimation(nil) {
                                refreshTimetable.toggle()
                            }
                        } else {
                            logger.info("Getting TimeTable for current week failed: \(selectedWeek)")
                        }
                    }
                } label: {
                    let week = String(days?.Days.first?.Date ?? "xy") + " - " + String(days?.Days.last?.Date ?? "xy")
                    Text(formatDateRange(week) ?? "xy")
                    .font(
                        Font.custom("Inter", size: 16)
                            .weight(.heavy)
                    )
                    .foregroundColor(.white)
                    .frame(width: 150, height: 48)
                }

                Button {
                    let nextWeek = selectedWeek + 604800 // Add interval for next week
                    selectedWeek = nextWeek
                    timetableRequest(date: nextWeek, accessToken: getTokenResponseFromUserDefaults()?.accessToken ?? "") { success in
                        if success {
                            logger.info("Getting TimeTable for last week successful: \(nextWeek)")
                            withAnimation(nil) {
                                refreshTimetable.toggle()
                            }
                        } else {
                            logger.info("Getting TimeTable for last week failed: \(nextWeek)")
                        }
                    }
                } label: {
                    Image(systemName: "arrowtriangle.right.fill")
                        .frame(width: 48, height: 48)
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 124)
                .padding(.vertical, 1)
                .frame(width: UIScreen.main.bounds.width, height: 50, alignment: .center)
                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                .frame(width: UIScreen.main.bounds.width, height: 45)
                .background(Color(red: 0.25, green: 0.25, blue: 0.25))
            }
        .fullScreenCover(isPresented: $refreshTimetable) {
            TimetableView(presentSideMenu: Binding.constant(false), selectedTimetable: 1)
        }
    }
}
