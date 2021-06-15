//
//  Issue.swift
//  Github Explorer
//
//  Created by inchurch on 14/06/21.
//

import SwiftUI

class Issue: Codable {
  let id: Int
  let title: String
  let html_url: String
  let user: Owner
  
  init(title: String, html_url: String, user: Owner, id: Int) {
    self.id = id
    self.title = title
    self.html_url = html_url
    self.user = user
  }
}
