//
//  IssuesApiRequest.swift
//  Github Explorer
//
//  Created by inchurch on 14/06/21.
//

import SwiftUI

class IssueApi {
  func getIssues(_ repository: String, completion: @escaping (Result<[Issue], Error>) -> (), typeErro: @escaping (String) -> ()) {
    guard let url = URL(string: "https://api.github.com/repos/\(repository)") else {return}

    URLSession.shared.dataTask(with: url) {data, response, error in
      if let error = error {
        completion(.failure(error))
        typeErro("error: \(String(describing: error.localizedDescription))")
        return
      }
      
      guard let responseCode = response as? HTTPURLResponse else {
        typeErro("Resposta vazia.")
        return
      }
      
      if responseCode.statusCode == 404 {
        typeErro("Repositório não encontrado")
        return
      }
      
      guard let data = data else {
        typeErro("Dados vazios.")
        return
      }

      do {
        let decoder = JSONDecoder()
        let issues = try decoder.decode([Issue].self, from: data)

        DispatchQueue.main.async {
          completion(.success(issues))
        }
      } catch let error {
        completion(.failure(error))
      }
    }.resume()
  }
}
