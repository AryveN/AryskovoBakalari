//
//  SideMenuView.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 28.11.2023.
//

import Foundation
import SwiftUI

struct SideMenuView: View {
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: 270)
                    .shadow(color: .purple.opacity(0.1), radius: 5, x: 0, y: 3)
                ScrollView(showsIndicators: false){
                    VStack(alignment: .leading, spacing: 0) {
                        ProfileImageView()
                            .frame(height: 140)
                            .padding(.bottom, 30)
                        
                        ForEach(SideMenuRowType.allCases, id: \.self){ row in
                            RowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title) {
                                selectedSideMenuTab = row.rawValue
                                presentSideMenu.toggle()
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 100)
                    .frame(width: 270)
                    .background(Color.white)
                }
            }
            
            
            Spacer()
        }
        .background(.clear)
    }
    
    func ProfileImageView() -> some View{
        VStack(alignment: .center)
        {
            HStack{
                Spacer()
                Image(systemName: "graduationcap.fill")
                    .resizable()
                    .foregroundColor(.black)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                Spacer()
            }

            if let userResponse = getUserResponseFromUserDefaults() {
                Text(userResponse.fullUserName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Text(userResponse.classInfo.abbrev ?? "X Y")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black.opacity(0.5))
            } else {
                Text("X Y")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Text("XY.Z")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black.opacity(0.5))
            }
        }
    }
    func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (() -> Void)) -> some View {
        Button(action: action) {
            HStack(spacing: 20) {
                Rectangle()
                    .fill(isSelected ? Color.purple : Color.white)
                    .frame(width: 5)

                Image(systemName: imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(isSelected ? Color.black : Color.gray)
                    .frame(width: 26, height: 26)

                Text(title)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(isSelected ? Color.black : Color.gray)

                Spacer()
            }
        }
        .frame(height: 50)
        .background(
            LinearGradient(colors: [isSelected ? Color.purple.opacity(0.5) : Color.white, Color.white],
                           startPoint: .leading, endPoint: .trailing)
        )
    }
}
