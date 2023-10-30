//
//  ContentView.swift
//  Quizz App IOS
//
//  Created by Marcelo on 2023-10-07.
//

import SwiftUI

struct ContentView: View {
    let question = Question(questionText: "What was the first computer bug",
    possibleAnswers:["Ant","Beetle","Moth","FLy"],   correctAnswerIndex: 2)
    
    @State var mainColor = GameColor.main

    var body: some View {
        ZStack{
            mainColor.ignoresSafeArea()
            VStack{
                Text("1/10")
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .padding()
                Text(question.questionText)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.leading)
                Spacer()
                HStack{
                    ForEach(0..<question.possibleAnswers.count) { answerIndex in
                      // Define the view that will be returned for each index
                        Button(action: {
                          print("Tapped on option with the text: \(question.possibleAnswers[answerIndex])")
                            if answerIndex == question.correctAnswerIndex{
                                mainColor = GameColor.correctGuess
                            }else{
                                mainColor = GameColor.incorrectGuess
                            }
                        }, label: {
                          ChoiceTextView(choiceText: question.possibleAnswers[answerIndex])
                        })
                    }
                }
            }
        }.foregroundColor(.white)
//        VStack {
//            Image(systemName:"flame")
//                .aspectRatio(contentMode: .fill)
//                .imageScale(.large)
//                .foregroundColor(.purple)
//            Text("Hello World!")
//                .font(.largeTitle)
//                .fontWeight(.semibold)
//                .foregroundColor(Color.yellow)
//            Button("Button title") {
//                print("Button tapped! \(count)");
//                count = count + 1;
//            }
//            .padding(.all, 2.0)
//            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.purple/*@END_MENU_TOKEN@*/)
//            .cornerRadius(/*@START_MENU_TOKEN@*/9.0/*@END_MENU_TOKEN@*/)
//            Text("Button clicked: \(count) times");
//
//        }
//       .padding()
//        .frame(width: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/)
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
