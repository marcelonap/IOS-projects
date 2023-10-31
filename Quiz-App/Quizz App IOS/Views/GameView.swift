//
//  ContentView.swift
//  Quizz App IOS
//
//  Created by Marcelo on 2023-10-07.
//

import SwiftUI

struct GameView: View {
    let question = Question(questionText: "What was the first computer bug",
    possibleAnswers:["Ant","Beetle","Moth","FLy"],   correctAnswerIndex: 2)
    
    //@State var mainColor = GameColor.main
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
          GameColor.main.ignoresSafeArea()
          VStack {
            Text(viewModel.questionProgressText)
              .font(.callout)
              .multilineTextAlignment(.leading)
              .padding()
            QuestionView(question: viewModel.currentQuestion)
          }
        }
        .foregroundColor(.white)
        .navigationBarBackButtonHidden(true)
        .environmentObject(viewModel)
        .background(    //use this to change screens after connecting to crg
        NavigationLink(destination: Text("Game Over"),
                       isActive: .constant(viewModel.gameIsOver), //constant returns binding to a value
                       label: {EmptyView()}
                      )
                    )
      }
}
   


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
