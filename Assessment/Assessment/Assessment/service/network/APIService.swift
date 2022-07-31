//
//  APIService.swift
//  Assessment
//
//  Created by Geniusjames on 30/07/2022.
//

import Foundation

enum CityAPIRequest {
    case fetchCities(page: String)
    case getFilteredCities(name: String, page: String)
    
}

extension CityAPIRequest {
    var method: Method {
        switch self {
        case .fetchCities:
            return .get
        case .getFilteredCities:
            return .get
        }
    }
    
    var baseUrl: URL {
        guard let url = URL(string: "http://connect-demo.mobile1.io/square1/connect/v1/city") else { fatalError() }
        return url
    }
    
    var queries: [String: String] {
        switch self {
        case .fetchCities(let page):
            return ["page": page]
        case .getFilteredCities(let name, let page):
            return ["filter[0][name][contains]": name, "page": page]
        }
    }
    
}



class APIService {
    
    static let shared = APIService()
    
    private func createRequest(apiRequest: CityAPIRequest) -> URLRequest? {

        let url = apiRequest.baseUrl
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = apiRequest.method.rawValue
        
        let parameters = apiRequest.queries
            switch apiRequest.method {
            case .get:
                var urlComponents = URLComponents(string: "\(url)")
                
                urlComponents?.queryItems = parameters.map {
                    URLQueryItem(name: $0, value: "\($1)") }
                request.url = urlComponents?.url
            case .post:
                break
            }
        return request
    }
    
    func request<T:Decodable>(request: CityAPIRequest,
                              completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = createRequest(apiRequest: request) else {return}
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            var result: Result<Data, Error>?
            if let data = data {
                result = .success(data)
            }
            if let error = error {
                result = .failure(error)
            }
            if let response = response as? HTTPURLResponse{
                print(response)
            }
            self.handleResponse(result: result, completion: completion)
        }.resume()
    }
    
    
    private func handleResponse<T: Decodable>(result: Result<Data, Error>?, completion: ((Result<T, Error>) -> Void)) {
        guard let result = result else {
            return
        }
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(T.self, from: data) else {
                return
            }
            completion(.success(response))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
