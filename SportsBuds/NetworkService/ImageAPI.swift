//
//  ImageAPI.swift
//  SportsBuds
//
//  Created by Rammel on 2022-04-07.
//

import Foundation
import UIKit

enum ImageAPIGetResult {
    case success(Bool)
    case failure(Error)
}

enum ImageAPIPostResult {
    case success(Bool)
    case failure(Error)
}

struct ImageAPI {
    public static let baseURL = "https://sportsbuds.azurewebsites.net"
    public static let imageURL = "https://sportsbuds.azurewebsites.net/api/Image"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //Create post
    public static func create(url: String = imageURL, imageData: Data, parameters: [String: String]?, callback: @escaping (ImageAPIPostResult) -> Void) {
        
        guard
            let url = APIHelper.buildURL(url: url, parameters: parameters)
        else{return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        request.setValue("multipart/form-data", forHTTPHeaderField: "Accept")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
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

