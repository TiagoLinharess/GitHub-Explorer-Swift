//
//  ContentView.swift
//  Github Explorer
//
//  Created by inchurch on 12/06/21.
//

import SwiftUI

struct RepositoriesList: View {
  @ObservedObject var repositoryViewModel: RepositoryApiViewModel
  @State private var repositoryName = ""
  
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
          searchAction()
        } label: {
          buttonLabel()
        }
        
        Spacer()
        
        ScrollView {
          renderRepositories()
        }
      }
      .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    .alert(isPresented: $repositoryViewModel.showingAlert) {
      Alert(
        title: Text(repositoryViewModel.alertTitle),
        message: Text(repositoryViewModel.alertText),
        dismissButton: .default(Text("OK"))
      )
    }
  }
  
  @ViewBuilder func buttonLabel() -> some View {
    if repositoryViewModel.isLoading {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
          .frame(width: 300, height: 50, alignment: .center)
          .background(Color.green)
          .clipShape(RoundedRectangle(cornerRadius: 10))
    } else {
       Text("Search")
         .frame(width: 300, height: 50, alignment: .center)
         .background(Color.green)
         .foregroundColor(.white)
         .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }
  
  @ViewBuilder func renderRepositories() -> some View {
    if repositoryViewModel.repositoriesCount > 0 {
      RepositoryList(repositories: repositoryViewModel.repositories)
    }
  }
  
  func searchAction() {
    if !repositoryViewModel.isLoading {
      repositoryViewModel.callApi(repositoryName)
    }
  }
}

struct RepositoriesList_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RepositoriesList(repositoryViewModel: RepositoryApiViewModel())
      RepositoriesList(repositoryViewModel: RepositoryApiViewModel())
    }
  }
}
