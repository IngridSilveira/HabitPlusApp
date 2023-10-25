//
//  WebService.swift
//  HabitPlus
//
//  Created by userext on 04/10/23.
//

import Foundation

enum WebService {
    
    enum EndPoint: String {
        case base = "https://habitplus-api.tiagoaguiar.co"
        case postUser = "/user"
    }
    
    private static func completeUrl(path: EndPoint) -> URLRequest? {
        guard let url = URL(string: "\(EndPoint.base.rawValue)\(path.rawValue)") else { return nil }
        
        return URLRequest(url: url)
    }
    
    static func postUser(request: SignUpRequest) {
        guard let jsonData = try? JSONEncoder().encode(request) else { return }
        
        guard var urlRequest = completeUrl(path: .postUser) else { return }
        
        urlRequest.httpMethod = "Post"
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error)
                return
            }
            print(String(data: data, encoding: .utf8))
            print("response")
            print(response)
            
            if let r = response as? HTTPURLResponse {
                print(r.statusCode)
            }
        }
        task.resume()
    }
}
