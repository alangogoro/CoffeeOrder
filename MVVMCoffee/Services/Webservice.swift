//
//  Webservice.swift
//  MVVMCoffee
//
//  Created by usr on 2021/9/1.
//

import Foundation

struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var httpBody: Data? = nil
    
    init(url: URL) {
        self.url = url
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

class Webservice {
    
    func load<T>(resource: Resource<T>,
                 completion: @escaping (Result<T, NetworkError>) -> Void ) {
        // ⭐️ 生成 URLRequest
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody   = resource.httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
}
