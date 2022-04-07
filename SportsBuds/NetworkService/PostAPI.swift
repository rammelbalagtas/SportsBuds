//
//  APIHelper2.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-15.
//

import Foundation

enum PostApiResult {
    case success([Post])
    case failure(Error)
}

enum PostDataResult {
    case success(Post)
    case failure(Error)
}

struct PostAPI {
    
    public static let baseURL = "https://sportsbuds.azurewebsites.net"
    public static let postURL = "https://sportsbuds.azurewebsites.net/api/posts"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //Fetch details of post
    public static func fetchPost(url: String, parameters: [String: String]?, callback: @escaping (PostApiResult) -> Void){
        guard
            let url = APIHelper.buildURL(url: url, parameters: parameters)
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
                callback(.failure(error))
            }
        }
    }
    
    //Create post
    public static func create(url: String = postURL, post: Post, callback: @escaping (PostDataResult) -> Void) {
        
        guard
            let url = URL(string: url)
        else{fatalError()}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
                callback(.failure(error))
                return
            }
            
            guard
                let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode
            else {
                print("Error: HTTP request failed")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let post = try decoder.decode(Post.self, from: data)
                    callback(.success(post))
                } catch let e {
                    print("could not parse json data: \(e)")
                }
            }
        }
        task.resume()
    }
    
    //Update Post
    public static func update(url: String = postURL, post: Post, callback: @escaping (PostDataResult) -> Void) {
        
        guard
            var url = URL(string: url)
        else{fatalError()}
        
        let tempURL = url.appendingPathComponent("/\(post.id)")
        url = tempURL

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
                callback(.failure(error))
                return
            }
            
            guard
                let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode
            else {
                print("Error: HTTP request failed")
                return
            }
            
            callback(.success(post))
            
        }
        task.resume()
    }
    
    //Delete Post
    public static func delete(url: String = postURL, post: Post, callback: @escaping (PostDataResult) -> Void) {
        
        guard
            var url = URL(string: url)
        else{fatalError()}
        
        let tempURL = url.appendingPathComponent("/\(post.id)")
        url = tempURL

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
                callback(.failure(error))
            }
            
            guard
                let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode
            else {
                print("Error: HTTP request failed")
                return
            }
            
            callback(.success(post))
            
        }
        task.resume()
    }
}


