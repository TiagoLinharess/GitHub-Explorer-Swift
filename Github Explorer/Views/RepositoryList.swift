//
//  RepositoryList.swift
//  Github Explorer
//
//  Created by inchurch on 13/06/21.
//

import SwiftUI

struct RepositoryList: View {
  let repositories: [Repository]
  
  var body: some View {
    ForEach(0 ..< repositories.count, id: \.self) { index in
      VStack {
        RemoteImage(url: repositories[index].owner.avatar_url)
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
        
        Text(repositories[index].name)
      }
      .padding()
      .frame(width: 300, height: 150, alignment: .center)
      .background(Color.init(hex: "EBEDEF"))
      .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
  }
}

struct RepositoryList_Previews: PreviewProvider {
  static var previews: some View {
    let repositories: [Repository] = []
    RepositoryList(repositories: repositories)
  }
}
