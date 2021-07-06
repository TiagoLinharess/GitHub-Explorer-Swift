//
//  RepoInfo.swift
//  Github Explorer
//
//  Created by inchurch on 14/06/21.
//

import SwiftUI

struct RepoInfo: View {
  let repository: Repository
  @ObservedObject var repoInfoViewModel: RepoInfoViewModel
  
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
          repoInfo()
          handleShowIssues()
          handleShowLoadMore()
        }
      }
      Spacer()
    }
    .onAppear{repoInfoViewModel.handleLoadIssues(repository: repository)}
    .alert(isPresented: $repoInfoViewModel.showingAlert) {
      Alert(title: Text(repoInfoViewModel.alertTitle), message: Text(repoInfoViewModel.alertText), dismissButton: .default(Text("OK")))
    }
  }
  
  @ViewBuilder func repoInfo() -> some View {
    let arr = [
      "Language \(repository.language)",
      "\(repository.subscribers_count) subscribers",
      "\(repository.forks) forks",
    ]
    
    ForEach(0 ..< 3) { index in
      Text(arr[index])
        .font(.title3)
        .fontWeight(.heavy)
    }
    
    HStack {
      Text("Issues (\(repository.open_issues_count))")
        .font(.title3)
        .fontWeight(.heavy)
      Spacer()
    }.padding()
  }
  
  @ViewBuilder func handleShowLoadMore() -> some View {
    if repoInfoViewModel.issues.count > 0 && repoInfoViewModel.issues.count != repository.open_issues_count && !repoInfoViewModel.isLoading {
      Button {
        if !repoInfoViewModel.isLoading {
          repoInfoViewModel.handleLoadIssues(repository: repository)
        }
      } label: {
        Text("Load more")
          .padding()
      }
    } else if repoInfoViewModel.isLoading && repoInfoViewModel.issues.count > 0 {
      ProgressView()
    }
  }
  
  @ViewBuilder func handleShowIssues() -> some View {
    if repoInfoViewModel.isLoading && repoInfoViewModel.issues.count == 0 {
      ProgressView()
    } else if repoInfoViewModel.issues.count == 0 {
      Text("There is no issues.")
        .foregroundColor(.red)
        .bold()
    } else {
      IssuesList(issues: repoInfoViewModel.issues)
    }
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
    
    RepoInfo(repository: repository, repoInfoViewModel: RepoInfoViewModel())
  }
}
