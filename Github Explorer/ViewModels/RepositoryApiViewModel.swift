//
//  RepositoryApiViewModel.swift
//  Github Explorer
//
//  Created by inchurch on 22/06/21.
//

import SwiftUI

class RepositoryApiViewModel: ObservableObject {
  @AppStorage("repositories") var repositories: [Repository] = []
  let apiRequest = Api()
  @Published var isLoading = false
  @Published var showingAlert = false
  @Published var alertTitle = ""
  @Published var alertText = ""
  var repositoriesCount: Int {
    return repositories.count
  }
  
  func callApi(_ repositoryName: String) {
    self.isLoading = true
    
    if repositoryName == "" {
      showingAlert = true
      alertTitle = "Attention!"
      alertText =  "Please, do not search with the text field empty."
      
      self.isLoading = false
      return
    }
    
    apiRequest.callRepository(repositoryName) { repository in
      if case .success(let repoData) = repository {
        if let _ = self.repositories.firstIndex(where: {$0.id == repoData.id}) {
          self.isLoading = false
          self.showingAlert = true
          self.alertTitle = "Ops"
          self.alertText =  "This repository has already been added to the list."
          return
        }
        
        self.repositories.append(repoData)
        self.isLoading = false
      } else {
        self.showingAlert = true
        self.alertTitle = "Error"
        self.alertText =  "There was a problem consulting GitHub, try again later."
        self.isLoading = false
        return
      }
    } typeErro: { erro in
      DispatchQueue.main.async {
        self.showingAlert = true
        self.alertTitle = "Error"
        self.alertText =  erro
        self.isLoading = false
      }
    }
  }
}
