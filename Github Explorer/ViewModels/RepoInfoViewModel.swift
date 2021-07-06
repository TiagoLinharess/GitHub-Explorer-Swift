//
//  RepoInfoViewModel.swift
//  Github Explorer
//
//  Created by inchurch on 22/06/21.

import SwiftUI

class RepoInfoViewModel: ObservableObject {
  let apiRequest = IssueApi()
  @Published var isLoading = false
  @Published var showingAlert = false
  @Published var alertTitle = ""
  @Published var alertText = ""
  @Published var issues: [Issue] = []
  @Published var actualPage = 1
  
  func handleLoadIssues(repository: Repository) {
    self.isLoading = true
    let query = repository.full_name + "/issues?page=\(actualPage)"
    
    apiRequest.getIssues(query) { newIssues in
      if case .success(let repoIssues) = newIssues {
        self.issues.append(contentsOf: repoIssues)
        self.isLoading = false
      } else {
        self.showingAlert = true
        self.alertText = "Ocorreu um erro ao consultar o GitHub, tente novamente."
        self.alertTitle = "Erro"
        self.isLoading = false
      }
    } typeErro: { erro in
      self.showingAlert = true
      self.alertText = erro
      self.alertTitle = "Erro"
      self.isLoading = false
    }
    actualPage += 1
  }
}
