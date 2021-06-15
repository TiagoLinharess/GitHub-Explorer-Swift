//
//  ContentView.swift
//  Github Explorer
//
//  Created by inchurch on 12/06/21.
//

import SwiftUI

struct RepositoriesList: View {
  @AppStorage("repositories") var repositories: [Repository] = []
  
  @State private var repositoryName = ""
  @State private var isLoading = false
  
  @State private var showingAlert = false
  @State private var AlertTitle = ""
  @State private var AlertText = ""
  
  var body: some View {
    NavigationView {
      VStack {
        TextField("Text the repository name...", text: $repositoryName)
          .autocapitalization(.none)
          .padding(10)
          .font(Font.system(size: 20, weight: .medium, design: .rounded))
          .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
          .frame(width: 300, height: 50, alignment: .center)
          .background(
            Image("background")
              .frame(width: 650, height: 650, alignment: .top)
              .offset(x: 60, y: 150)
              .opacity(0.1)
              .toolbar {
                ToolbarItem(placement: .primaryAction) {
                  Image("logo")
                    .frame(width: 500, height: 60, alignment: .center)
                }
              }
          )
        
        Button {
          if !isLoading {
            getRepository()
          }
        } label: {
          buttonLabel()
        }
        
        Spacer()
        
        ScrollView {
          renderRepositories()
        }
        
        Spacer()
      }
      .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    .alert(isPresented: $showingAlert) {
      Alert(title: Text(AlertTitle), message: Text(AlertText), dismissButton: .default(Text("OK")))
    }
  }
  
  func buttonLabel() -> some View {
    if isLoading {
      return AnyView(
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
          .frame(width: 300, height: 50, alignment: .center)
          .background(Color.green)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      )
    }
    
    return AnyView(
      Text("Search")
        .frame(width: 300, height: 50, alignment: .center)
        .background(Color.green)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    )
  }
  
  func renderRepositories() -> some View {
    if repositories.count > 0 {
      let view = AnyView(
        RepositoryList(repositories: repositories)
      )
      
      return view
    }
    
    let view = AnyView(Text(""))
    
    return view
  }
  
  func getRepository() {
    isLoading = true
    
    if repositoryName == "" {
      showingAlert = true
      AlertText = "Please, do not search with the text field empty."
      AlertTitle = "Attention!"
      
      isLoading = false
      return
    }
    
    Api().getPosts(repositoryName) { repository in
      if case .success(let repoData) = repository {
        if (repositories.first(where: {$0.id == repoData.id}) != nil) {
          showingAlert = true
          AlertText = "This repository has already been added to the list."
          AlertTitle = "Ops"
          
          isLoading = false
          return
        }
        
        self.repositories.append(repoData)
      } else {
        showingAlert = true
        AlertText = "There was a problem consulting GitHub, try again later."
        AlertTitle = "Error"
      }
    } typeErro: { erro in
      showingAlert = true
      AlertText = erro
      AlertTitle = "Error"
    }
    
    isLoading = false
  }
}

struct RepositoriesList_Previews: PreviewProvider {
  static var previews: some View {
    RepositoriesList()
  }
}
