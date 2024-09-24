//
//  TimetableHours.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 27.02.2024.
//

import SwiftUI

struct TimetableHours: View {
    @Binding var presentSideMenu: Bool
    @State private var backToggle: Bool = false
    @State private var showingAlert = false
    @State private var redirectLogin = false
    @Environment(\.colorScheme) var colorScheme
    let days = try getDaysResponseFromUserDefaults()
    
    var body: some View {
        HStack(spacing: 0) {
            
            let hours = getHoursResponseFromUserDefaults()
            
            ForEach(1..<(getMaxHourID(from: days)-1)) { index in
                ZStack {
                    Rectangle()
                        .frame(width: 90, height: 42)
                        .background(Color(red: 0.98, green: 0.52, blue: 0.99))
                        .overlay(
                            Rectangle()
                                .inset(by: -0.5)
                                .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 1.5)
                        )
                    
                    VStack {
                        Text("\(index).")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                        Text((hours?.Hours[index-1].BeginTime ?? "") + "-" + (hours?.Hours[index-1].EndTime ?? ""))
                            .font(.system(size: 12))
                    }
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                }
            }
        }
    }
}
