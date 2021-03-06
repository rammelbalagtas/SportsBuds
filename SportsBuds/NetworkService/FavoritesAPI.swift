//
//  APIHelper2.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-15.
//

import Foundation

enum FavoritesApiResult {
    case success([Post])
    case failure(Error)
}

enum CreateFavoriteResult {
    case success(Bool)
    case failure(Error)
}

enum DeleteFavoriteResult {
    case success(Bool)
    case failure(Error)
}

struct FavoritesAPI {
    
    public static let baseURL = "https://sportsbuds.azurewebsites.net"
    public static let favoritesURL = "https://sportsbuds.azurewebsites.net/api/favorites"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //Fetch details of movie
    public static func get(url: String, parameters: [String: String]?, callback: @escaping (FavoritesApiResult) -> Void){
        guard
            let url = APIHelper.buildURL(url: url, parameters: parameters)
        else{return}
        APIHelper.fetch(url: url) { fetchResult in
            switch fetchResult {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let favoritesAPIList = try decoder.decode([Post].self, from: data)
                    callback(.success(favoritesAPIList))
                } catch let e {
                    print("could not parse json data \(e)")
                }
            case .failure(let error):
                print("there was an error fetchin information \(error)")
                callback(.failure(error))
            }
        }
    }
    
    //Add favorites
    public static func create(url: String = favoritesURL, parameters: [String: String]?, callback: @escaping (CreateFavoriteResult) -> Void) {
        
        guard
            let url = APIHelper.buildURL(url: url, parameters: parameters)
        else{return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) {
            data, response, error in
            
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
                return
            }
            
            guard
                let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode
            else {
                print("Error: HTTP request failed")
                return
            }
            
            callback(.success(true))
        }
        task.resume()
    }
    
    //Delete Favorites
    public static func delete(url: String = favoritesURL, parameters: [String: String]?, callback: @escaping (DeleteFavoriteResult) -> Void) {
        
        guard
            let url = APIHelper.buildURL(url: url, parameters: parameters)
        else{return}

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request) {
            data, response, error in
            
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
                callback(.failure(error))
                return
            }
            
            guard
                let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode
            else {
                print("Error: HTTP request failed")
                return
            }
            
            callback(.success(true))
            
        }
        task.resume()
    }
}


