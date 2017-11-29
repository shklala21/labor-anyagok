//
//  NetworkHelper.swift
//  Messenger
//
//  Copyright © 2017. BME AUT. All rights reserved.
//

import UIKit

class NetworkHelper {
  
  static var urlSession: URLSession = {
    let sessionConfiguration = URLSessionConfiguration.default
    return URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
  }()
  
  static var imageCache = [URL: UIImage]()
  
  static func downloadMessages(completion: @escaping ([Message])->()) {
    let url = URL(string: "http://atleast.aut.bme.hu/ait-ios/messenger/messages")
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    urlSession.dataTask(with: url!) { data, response, error in
      defer {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
      
      if let error = error {
        print("Error during communication \(error.localizedDescription)")
      } else if let data = data {
        let decoder = JSONDecoder()
        do {
          let messages = try decoder.decode(Array<Message>.self, from: data)
          completion(messages)
        } catch let decodeError {
          print("Error during JSON decoding \(decodeError.localizedDescription)")
        }
      }
      }.resume()
  }
  
  static func uploadMessage(jsonData: Data, completion: @escaping (UIAlertController)->()) {
    let url = URL(string: "http://atleast.aut.bme.hu/ait-ios/messenger/add-message")
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    urlSession.uploadTask(with: request, from: jsonData) { data, response, error in
      defer {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
      
      if let error = error {
        print("Error during comminication: \(error.localizedDescription).")
        return
      } else if let data = data {
        let decoder = JSONDecoder()
        do {
          let sendResponse = try decoder.decode(MessageSendResponse.self, from: data)
          
          let alert = UIAlertController(title: "Server response", message: sendResponse.result, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
          alert.addAction(okAction)
          
          completion(alert)
        } catch {
          print("Error during JSON decoding: \(error.localizedDescription)")
        }
      }
      }.resume()
  }
  
  static func downloadImage(with url: URL, completion: @escaping (UIImage)->()) {
    if let cachedImage = imageCache[url] {
      completion(cachedImage)
    }
    else {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      NetworkHelper.urlSession.dataTask(with: url) { data, response, error in
        defer {
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        if let data = data, let image = UIImage(data: data) {
          self.imageCache[url] = image
          completion(image)
        }
      }.resume()
    }
  }
  
}
