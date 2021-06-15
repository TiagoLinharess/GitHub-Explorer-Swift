//
//  IssuesList.swift
//  Github Explorer
//
//  Created by inchurch on 14/06/21.
//

import SwiftUI
import SafariServices

struct IssuesList: View {
  let issues: [Issue]
  @State var showSafari = false
  @State var indexToSafari = 0
  
  var body: some View {
    ForEach(0 ..< issues.count, id: \.self) { index in
      HStack(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/) {
        RemoteImage(url: issues[index].user.avatar_url)
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
          .frame(width: 60, height: 60, alignment: .center)
        
        Text(issues[index].title)
        
        Spacer()
      }
      .onTapGesture {
        indexToSafari = index
        showSafari = true
      }
      .sheet(isPresented: $showSafari) {
        SafariView(url:URL(string: issues[indexToSafari].html_url)!)
      }
      .padding()
      .frame(width: 300, height: 80, alignment: .center)
      .background(Color.init(hex: "EBEDEF"))
    }
  }
}

struct SafariView: UIViewControllerRepresentable {
  let url: URL

  func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
    return SFSafariViewController(url: url)
  }
  
  func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
  }
}

struct IssuesList_Previews: PreviewProvider {
  static var previews: some View {
    let issues: [Issue] = []
    IssuesList(issues: issues)
  }
}
