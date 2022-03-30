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
    case success([Post])
    case failure(Error)
}

enum PostDataResult {
    case success(Post)
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
    public static let postURL = "https://sportsbuds.azurewebsites.net/api/posts"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
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
                    let postApiList = try decoder.decode([Post].self, from: data)
                    callback(.success(postApiList))
                } catch let e {
                    print("could not parse json data \(e)")
                }
            case .failure(let error):
                print("there was an error fetchin information \(error)")
            }
        }
    }
    
    //Post data to API (for POST and PUT methods)
    public static func postData(url: String = postURL, post: Post, httpMethod: String, callback: @escaping (PostDataResult) -> Void) {
        
        guard
            var url = URL(string: url)
        else{fatalError()}
        
        if httpMethod == "PUT" || httpMethod == "DELETE" {
            let tempURL = url.appendingPathComponent("/\(post.id)")
            url = tempURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(post)
            request.httpBody = jsonData
        } catch let e {
            print("could not parse convert json data: \(e)")
        }
        
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
            
            if httpMethod == "POST" {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let post = try decoder.decode(Post.self, from: data)
                        callback(.success(post))
                    } catch let e {
                        print("could not parse json data: \(e)")
                        callback(.success(post))
                    }
                }
            } else {
                callback(.success(post))
            }
            
        }
        task.resume()
    }
}


