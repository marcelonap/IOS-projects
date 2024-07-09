//
//  ContentView.swift
//  NFCTester
//
//  Created by Marcelo Napoleao Sampaio on 2024-03-29.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var viewModel : NFCReaderViewModel

    var body: some View {
        VStack {
            Button("Read NFC Tag") {
                viewModel.beginScanning()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        Text("Data in tag:")
            Spacer()
            
            List(viewModel.readMessages, id: \.self) { message in
                Text(message)
            }
            
        }
    }
}


#Preview {
    ContentView()
}
