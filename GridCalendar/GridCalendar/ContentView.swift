//
//  ContentView.swift
//  GridCalendar
//
//  Created by Marcelo Napoleao Sampaio on 2023-11-19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


struct Day: Identifiable {
    let id = UUID()
    let value: Int
}
