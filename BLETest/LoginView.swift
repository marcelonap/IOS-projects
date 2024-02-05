//
//  LoginView.swift
//  BLETest
//
//  Created by Marcelo Napoleao Sampaio on 2024-01-04.
//

import SwiftUI


struct LoginView: View {
  
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Login") {
                            // Trigger the login function in ViewModel
                            Task {
                                await viewModel.login()
                            }
                        }
                        .disabled(viewModel.isLoading) 
            .padding()
            if viewModel.isLoading {
                ProgressView()
            } else {
                List(viewModel.thingstreamObjects, id: \.domainId) { object in
                    VStack(alignment: .leading) {
                        Text("Domain ID: \(object.domainId)")
                        Text("Domain Name: \(object.domainName)")
                        Text("Authorizaion Key: \(object.authKey)")
                        Text("Authorization Secret: \(object.authSecret)")
                    }
                }
            }
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
