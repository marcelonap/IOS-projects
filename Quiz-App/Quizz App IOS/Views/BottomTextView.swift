//
//  BottomTextView.swift
//  Quizz App IOS
//
//  Created by Marcelo on 2023-10-27.
//

import SwiftUI

struct BottomTextView: View {
    let str: String
    
    var body: some View {
        
        HStack{
            Spacer()
            Text(str)
                .font(.body)
                .bold()
                .padding()
            Spacer()
        }.background(GameColor.accent)
    }
}

#Preview {
    BottomTextView(str: "lets go")
}
