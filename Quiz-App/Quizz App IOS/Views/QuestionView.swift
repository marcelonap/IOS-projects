//
//  QuestionView.swift
//  Quizz App IOS
//
//  Created by Marcelo on 2023-10-31.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var viewModel: GameViewModel
    let question: Question
    
    var body: some View {
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
                        viewModel.makeGuess(atIndex: answerIndex)
                    }) {
                        ChoiceTextView(choiceText: question.possibleAnswers[answerIndex])
                            .background(viewModel.color(forOptionIndex: answerIndex))
                    }
                    .disabled(viewModel.guessWasMade)
                }
            }
            if viewModel.guessWasMade{
                
                Button(action: {viewModel.displayNextScreen()}){
                    BottomTextView(str: "Next")
                }
            }
        
    }
}

#Preview {
    QuestionView(question: Game().currentQuestion)
}
