//
//  RepoInfo.swift
//  Github Explorer
//
//  Created by inchurch on 14/06/21.
//

import SwiftUI

struct RepoInfo: View {
  let repository: Repository
  
  @State private var issues: [Issue] = []
  @State private var isLoading = true
  @State private var actualPage = 1
  
  @State private var showingAlert = false
  @State private var AlertTitle = ""
  @State private var AlertText = ""
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        RemoteImage(url: repository.owner.avatar_url)
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
          .frame(width: 100, height: 100, alignment: .leading)
          .background(
            Image("background")
              .frame(width: 650, height: 650, alignment: .top)
              .offset(x: -60, y: 130)
              .opacity(0.1)
          )
        
        Text(repository.full_name)
          .font(.largeTitle)
          .fontWeight(.heavy)
        
        VStack(spacing: 10) {
          Text("Language \(repository.language)")
            .font(.title3)
            .fontWeight(.heavy)
          
          Text("\(repository.subscribers_count) subscribers")
            .font(.title3)
            .fontWeight(.heavy)
          
          Text("\(repository.forks) forks")
            .font(.title3)
            .fontWeight(.heavy)
          
          HStack {
            Text("Issues (\(repository.open_issues_count))")
              .font(.title3)
              .fontWeight(.heavy)
            Spacer()
          }.padding()
          
          handleShowIssues()
          handleShowLoadMore()
        }
      }
      Spacer()
    }
    .onAppear{handleLoadIssues(page: actualPage)}
    .alert(isPresented: $showingAlert) {
      Alert(title: Text(AlertTitle), message: Text(AlertText), dismissButton: .default(Text("OK")))
    }
  }
  
  func handleShowLoadMore() -> some View {
    if issues.count > 0 {
      return AnyView(
        Button {
          if !isLoading {
            handleLoadIssues(page: actualPage)
          }
        } label: {
          Text("Load more")
            .padding()
        }
      )
    }
    
    return AnyView(Text(""))
  }
  
  func handleShowIssues() -> some View {
    if isLoading {
      return AnyView(ProgressView())
    }
    
    if issues.count == 0 {
      return AnyView(
        Text("There is no issues.")
          .foregroundColor(.red)
          .bold()
      )
    }
    
    return AnyView(IssuesList(issues: issues))
  }
  
  func handleLoadIssues(page: Int) {
    let query = repository.full_name + "/issues?page=\(page)"
    
    IssueApi().getIssues(query) { newIssues in
      if case .success(let repoIssues) = newIssues {
        self.issues.append(contentsOf: repoIssues)
      } else {
        showingAlert = true
        AlertText = "Ocorreu um erro ao consultar o GitHub, tente novamente."
        AlertTitle = "Erro"
      }
    } typeErro: { erro in
      showingAlert = true
      AlertText = erro
      AlertTitle = "Erro"
    }
    
    isLoading = false
    actualPage += 1
  }
}

struct RepoInfo_Previews: PreviewProvider {
  
  static var previews: some View {
    let repository: Repository = Repository(
      id: 1234,
      name: "Tiago",
      full_name: "Tiago L",
      owner: Owner(login: "cccc", avatar_url: "bbbb"),
      language: "aa",
      open_issues_count: 789,
      forks: 123,
      subscribers_count: 456
    )
    
    RepoInfo(repository: repository)
  }
}
