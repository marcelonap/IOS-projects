//
//  RecipeData.swift
//  Cookcademy
//
//  Created by Marcelo Napoleao Sampaio on 2023-11-19.
//

import Foundation

class RecipeData: ObservableObject {
  @Published var recipes = Recipe.testRecipes
}
