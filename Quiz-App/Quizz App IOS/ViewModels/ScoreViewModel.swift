//
//  ScoreViewModel.swift
//  Quizz App IOS
//
//  Created by Marcelo on 2023-11-04.
//

import Foundation

struct ScoreViewModel{
    let correctGuesses: Int
    let incorrectGuesses: Int
    
    var percentage: Int{
        (correctGuesses*100)/(incorrectGuesses + correctGuesses)
    }
    
}
