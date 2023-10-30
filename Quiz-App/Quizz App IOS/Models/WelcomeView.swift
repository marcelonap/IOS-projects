//
//  WelcomeView.swift
//  Quizz App IOS
//
//  Created by Marcelo on 2023-10-27.
//

import SwiftUI

struct WelcomeView: View {
    //let accentColor = Color(red: 48/255, green: 105/255, blue: 240/255)
    //let mainColor = Color(red: 20/255, green: 28/255, blue: 58/255)
    
    var body: some View {
        NavigationView{
            ZStack{
                GameColor.main.ignoresSafeArea()
                VStack{
                    Spacer()
                    VStack(alignment: .leading, spacing: 0){
                        Text("Select the correct answers to the following questions. This is now on github!!")
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .padding()
                    }
                    Spacer()
                    NavigationLink(destination: ContentView(), label:{
                        BottomTextView(str: "Let's go!")
                    } )
                }
                .foregroundColor(.white)
            }
            
        }
    }
}

#Preview {
    WelcomeView()
}
