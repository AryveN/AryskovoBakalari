//
//  TimetableView.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 28.11.2023.
//

/*HStack{
 Button{
 presentSideMenu.toggle()
 } label: {
 Spacer().frame(width: 10)
 Image(systemName: "square.grid.3x3.fill")
 .resizable()
 .foregroundColor(colorScheme == .dark ? .black : .white)
 .frame(width: 64, height: 64)
 }
 Spacer()
 }*/

import Foundation
import SwiftUI

// Function to calculate the height dynamically
func calculateHeight(geometry: GeometryProxy) -> CGFloat {
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let navigationBarHeight = UINavigationController().navigationBar.frame.height
    let remainingHeight = (geometry.size.height - statusBarHeight - navigationBarHeight) / 5 // Subtract any other UI elements' heights from the total height
    return remainingHeight
}

func formatDateRange(_ dateString: String) -> String? {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
    
    let components = dateString.components(separatedBy: " - ")
    
    if components.count == 1 {
        if let date = dateFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateFormat = "d.M."
            return formatter.string(from: date)
        } else {
            return nil
        }
    } else if components.count == 2 {
        if let startDate = dateFormatter.date(from: components[0]),
           let endDate = dateFormatter.date(from: components[1]) {
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "d."
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "d.M.yyyy"
            
            let formattedStartDate = formatter1.string(from: startDate)
            let formattedEndDate = formatter2.string(from: endDate)
            
            return "\(formattedStartDate) - \(formattedEndDate)"
        } else {
            return nil
        }
    } else {
        return nil
    }
}

func getMaxHourID(from days: Days?) -> Int {
    guard let days = days else { return 0 }
    
    var maxHourID = 0
    
    for day in days.Days {
        for atom in day.Atoms {
            if atom.HourId > maxHourID {
                maxHourID = atom.HourId
            }
        }
    }
    
    return maxHourID
}

struct TimetableView: View {
    @Binding var presentSideMenu: Bool
    @State var selectedTimetable: Int = 1
    @State private var backToggle: Bool = false
    @State private var showingAlert = false
    @State private var redirectLogin = false
    @Environment(\.colorScheme) var colorScheme
    let days = try getDaysResponseFromUserDefaults()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // Return and Refresh
            TimetableNavbar(presentSideMenu: Binding.constant(false), colorScheme: Environment(\.colorScheme).self)
            
            //Rozvrh switch
            TimetableSwitch(presentSideMenu: Binding.constant(false), selectedTimetable: selectedTimetable, colorScheme: Environment(\.colorScheme).self)
            
            //Week
            TimetableWeek(presentSideMenu: Binding.constant(false), colorScheme: Environment(\.colorScheme).self)
            
            //Timetable
            TimetableFill(presentSideMenu: Binding.constant(false), colorScheme: Environment(\.colorScheme).self)
        }
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .fullScreenCover(isPresented: $redirectLogin) {
            LoginScreen()
        }
    }

}
#Preview {
    TimetableView(presentSideMenu: Binding.constant(false), colorScheme: Environment(\.colorScheme).self)
}
