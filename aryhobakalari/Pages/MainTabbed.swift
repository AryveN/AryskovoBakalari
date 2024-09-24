//
//  MainTabbed.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 28.11.2023.
//

import Foundation
import SwiftUI

struct MainTabbed: View {
    
    @State private var loginView = false
    @Environment(\.colorScheme) var colorScheme
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    
    var body: some View {
        return Group {
            ZStack{
                TabView(selection: $selectedSideMenuTab) {
                    MainScreen(logout: Binding.constant(false), presentSideMenu: $presentSideMenu)
                        .tag(0)
                    TimetableView(presentSideMenu: $presentSideMenu)
                        .tag(1)
                    MainScreen(logout: Binding.constant(true), presentSideMenu: $presentSideMenu)
                        .tag(12)
                }
                SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
            }
        }
    }
}
