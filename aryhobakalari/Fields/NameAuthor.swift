//
//  NameAuthor.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 10.09.2022.
//

import SwiftUI

struct NameAuthor: View {
    var body: some View {
        VStack {
            Text("UwUzvrh")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.purple)
            HStack {
                Text("Made by")
                    .font(.subheadline)
                Text("AryveN")
                    .font(.headline)
                    .padding(.leading, -5.0)
            }
        }
    }
}

struct NameAuthor_Previews: PreviewProvider {
    static var previews: some View {
        NameAuthor()
    }
}
