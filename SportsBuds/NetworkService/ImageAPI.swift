//
//  ImageAPI.swift
//  SportsBuds
//
//  Created by Rammel on 2022-04-07.
//

import Foundation
import UIKit

enum ImageAPIGetResult {
    case success(UIImage)
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
    
    //Fetch image
    public static func get(url: String = imageURL, parameters: [String: String]?, callback: @escaping (ImageAPIGetResult) -> Void){
        guard
            let url = APIHelper.buildURL(url: url, parameters: parameters)
        else{return}
        APIHelper.fetch(url: url) { response in
            switch response {
            case .success(let data):
                guard
                    let image = UIImage(data: data)
                else{return}
                callback(.success(image))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    //Post image
    public static func create(url: String = imageURL, imageData: Data, parameters: [String: String]?, callback: @escaping (ImageAPIPostResult) -> Void) {
        
        guard
            let url = APIHelper.buildURL(url: url, parameters: parameters)
        else{return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let httpBody = NSMutableData()
        httpBody.append(convertFileData(fieldName: "ImageFile",
                                        fileName: "image.jpg",
                                        mimeType: "image/jpg",
                                        fileData: imageData,
                                        using: boundary))
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data

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
    
    public static func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()
      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")
      return data as Data
    }
    
    public static func convertFormField(named name: String, value: String, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"
      return fieldString
    }

}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}

