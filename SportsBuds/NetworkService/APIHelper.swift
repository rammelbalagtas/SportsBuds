//
//  APIHelper2.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-15.
//

import Foundation

enum FetchResult {
    case success(Data)
    case failure(Error)
}

struct APIHelper {
    
    public static let baseURL = "https://sportsbuds.azurewebsites.net"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //prepare URL using API key and additional parameters
    public static func buildURL(url: String, parameters: [String: String]?) -> URL? {
        var components = URLComponents(string: url)!
        var queryItems = [URLQueryItem]()
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    //generic fetch method
    public static func fetch(url: URL, callback: @escaping (FetchResult) -> Void){
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            data, response, error in
            if let data = data {
                callback(.success(data))
            } else if let error = error{
                callback(.failure(error))
            }
        }
        task.resume()
    }
    
}


