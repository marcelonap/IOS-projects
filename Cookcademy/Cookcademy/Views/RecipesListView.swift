//
//  ContentView.swift
//  Cookcademy
//
//  Created by Marcelo Napoleao Sampaio on 2023-11-13.
//

import SwiftUI

struct RecipesListView: View {
  @StateObject var recipeData = RecipeData()
    private let listBackgroundColor = AppColor.background
    private let listTextColor = AppColor.foreground
    var body: some View {
        NavigationView{
            List {
                ForEach(recipes) { recipe in
                    //Text("help")
                    NavigationLink( recipe.mainInformation.name,
                                    destination: RecipeDetailView(recipe: recipe).environmentObject(self.recipeData)
                                    
                    )
                }.listRowBackground(listBackgroundColor)
                    .foregroundColor(listTextColor)

            }.listStyle(InsetGroupedListStyle())
                .navigationTitle(navigationTitle)
                .environmentObject(recipeData)
        }
    }
}

extension RecipesListView {
  var recipes: [Recipe] {
    recipeData.recipes
  }
  
  var navigationTitle: String {
    "All Recipes"
  }
}

struct RecipesListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      RecipesListView()
    }
  }
}
