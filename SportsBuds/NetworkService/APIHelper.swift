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

enum PostApiResult {
    case success([PostApi])
    case failure(Error)
}

struct PostApi : Codable {
    let id: Int
    let title: String
    let description: String
    let location: String
}

struct APIHelper {
    
    public static let baseURL = "https://sportsbuds.azurewebsites.net"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //generic fetch method
    public static func fetch(url: URL, callback: @escaping (FetchResult) -> Void){
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            data, request, error in
            
            if let data = data {
                callback(.success(data))
            } else if let error = error{
                callback(.failure(error))
            }
        }
        task.resume()
    }
    
    //Fetch details of movie
    public static func fetchPost(url: String, callback: @escaping (PostApiResult) -> Void){
        
        guard
            let url = URL(string: url)
        else{return}
    
        APIHelper.fetch(url: url) { fetchResult in
            switch fetchResult {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let postApiList = try decoder.decode([PostApi].self, from: data)
                    callback(.success(postApiList))
                } catch let e {
                    print("could not parse json data \(e)")
                }
            case .failure(let error):
                print("there was an error fetchin information \(error)")
            }
        }
    }
}


