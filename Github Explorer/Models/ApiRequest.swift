//
//  ApiRequest.swift
//  Github Explorer
//
//  Created by inchurch on 12/06/21.
//

import SwiftUI

class Api {
  func getPosts(_ repository: String, completion: @escaping (Result<Repository, Error>) -> (), typeErro: @escaping (String) -> ()) {
    guard let url = URL(string: "https://api.github.com/repos/\(repository)") else {return}

    URLSession.shared.dataTask(with: url) {data, response, error in
      if let error = error {
        completion(.failure(error))
        typeErro("error: \(String(describing: error.localizedDescription))")
        return
      }
      
      guard let responseCode = response as? HTTPURLResponse else {
        typeErro("Empty answer.")
        return
      }
      
      if responseCode.statusCode == 404 {
        typeErro("Repository not found.")
        return
      }
      
      guard let data = data else {
        typeErro("Empty data.")
        return
      }

      do {
        let decoder = JSONDecoder()
        let repository = try decoder.decode(Repository.self, from: data)

        DispatchQueue.main.async {
          completion(.success(repository))
        }
      } catch let error {
        completion(.failure(error))
      }
    }.resume()
  }
}
