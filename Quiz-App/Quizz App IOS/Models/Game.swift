//
//  Game.swift
//  Quizz App IOS
//
//  Created by Marcelo on 2023-10-26.
//

import Foundation

struct Game{
    private(set) var currentQuestionIndex = 0
    
    private(set) var isOver = false
    
    private(set) var guesses = [Question : Int]()
    
    private let questions = Question.allQuestions.shuffled()
    
    var guessCount: (correct: Int, incorrect: Int){
        var count: (correct: Int, incorrect: Int) = (0,0)
        for(question,guessIndex) in guesses{
            if question.correctAnswerIndex == guessIndex{
                count.correct += 1
            }else{
                count.incorrect += 1
            }
        }
        return count
    }
    
    var numberOfQuestions: Int {
        questions.count
    }
    
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }
    
    mutating func makeGuessForCurrentQuestion(atIndex index: Int){
        guesses[currentQuestion] = index
    }
    
    mutating func updateGameStatus(){
        if currentQuestionIndex < questions.count - 1{
            currentQuestionIndex+=1
        }else{
            isOver = true
        }
    }
    
    
}
