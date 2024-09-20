//
//  GitListInteractor.swift
//  GitHubSearch
//
//  Created by Nikolay Scherbakov on 20.09.2024.
//

import Foundation

enum Error: Swift.Error {
  case invalidURL
  case invalidData
  
  var localizedDescription: String {
    switch self {
      case .invalidURL:
        return NSLocalizedString("Invalid URL. Try another URL", comment: "My error")
      case .invalidData:
        return NSLocalizedString("Invalid Data. Try again", comment: "My error")
    }
  }
}

protocol GitListInteractorProtocol: AnyObject {
  func search(query: String, completion: ((GitItems?, Error?) -> Void)?)
  func cancel()
}

class GitListInteractor: GitListInteractorProtocol {
  private var task: URLSessionDataTask?
  
  func search(query: String, completion: ((GitItems?, Error?) -> Void)?) {
    guard let url = URL(string: "https://api.github.com/search/repositories?q=\(query)") else {
      completion?(nil, .invalidURL)
      return
    }
    
    task?.cancel()
    
    task = URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data else {
        completion?(nil, .invalidData)
        return
      }
      
      let items: GitItems
      do {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        print(json)
        
        items = try JSONDecoder().decode(GitItems.self, from: data)
      } catch {
        completion?(nil, .invalidData)
        return
      }
      
      completion?(items, nil)
    }
    
    task?.resume()
  }
  
  func cancel() {
    task?.cancel()
  }
}
