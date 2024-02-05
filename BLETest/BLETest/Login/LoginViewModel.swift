//
//  LoginViewModel.swift
//  BLETest
//
//  Created by Marcelo Napoleao Sampaio on 2024-01-04.
//


import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var thingstreamObjects: [ThingstreamObject] = []
        
    func getDeviceIdName() async {
        guard let url = URL(string: "https://api.thingstream.io/thing/search") else {return}
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let body : [String: String] = [
                    "X-Auth-Key": thingstreamObjects[0].authKey
                    "X-Auth-Secret":thingstreamObjects[0].authSecret
                ]
    }
//    
    func login() async {
        // ... setup request ...
        guard let url = URL(string: "https://api.thingstream.io/auth/keys/all") else { return }
           
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           let body: [String: String] = [
               "email": username,
               "password": password
           ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
           
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let jsonString = String(data: data, encoding: .utf8) else { return }
            print(jsonString)
            print("---------------------")
            // Manually parse the JSON string
//            let parsedObject = parseJSONString(jsonString)
//            print(parsedObject)
            //let parsedObject = parseJson(data: data)
            DispatchQueue.main.async {
                if let objects = self.parseJson(data: data) {
                                   self.thingstreamObjects = objects
                                   print(objects)
                               }
                
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                print(error)œ
            }
        }
    }
    


    func parseJSONString(_ jsonString: String) -> ThingstreamObject {
        var domainId = ""
        var domainName = ""
        var authKey = ""
        var authSecret = ""

        // Parse the string here - this is a rudimentary example
        // In practice, this would need to be more robust
        let lines = jsonString.split(separator: ",")

        for line in lines {
            if line.contains("\"domainId\":") {
                domainId = line.components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet(charactersIn: "\" "))
            } else if line.contains("\"domainName\":") {
                domainName = line.components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet(charactersIn: "\" "))
            } else if line.contains("\"authKey\":") {
                authKey = line.components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet(charactersIn: "\" "))
            } else if line.contains("\"authSecret\":") {
                authSecret = line.components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet(charactersIn: "\" "))
            }
        }

        return ThingstreamObject(domainId: domainId, domainName: domainName, authKey: authKey, authSecret: authSecret)
    }
    
    func parseJson(data: Data) -> [ThingstreamObject]? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(ApiResponse.self, from: data)
            return response.keys
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }



}
struct ApiResponse: Codable {
    let keys: [ThingstreamObject]
}

struct ThingstreamObject: Codable {
    var domainId: String
    var domainName: String
    var authKey: String
    var authSecret: String
}

