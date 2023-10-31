//
//  ScoreView.swift
//  Quizz App IOS
//
//  Created by Marcelo on 2023-10-31.
//

import SwiftUI


struct ScoreView: View {
  var body: some View {
      ZStack {
         GameColor.main.ignoresSafeArea()
         VStack {
           Spacer()
           Text("Final Score:")
             .font(.body)
           Text("???%")
             .font(.system(size: 50))
             .bold()
             .padding()
           Spacer()
           VStack {
             Text("??? ✅")
             Text("??? ❌")
           }.font(.system(size: 30))
           Spacer()
           NavigationLink(
             destination: GameView(),
             label: {
               BottomTextView(str: "Re-take Quiz")
             })
         }
         .foregroundColor(.white)
         .navigationBarHidden(true)
       }
  }
}

#Preview {
    ScoreView()
}
