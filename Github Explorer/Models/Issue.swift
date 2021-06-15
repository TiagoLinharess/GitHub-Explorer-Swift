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
  let url: String
  let user: Owner
  
  init(title: String, url: String, user: Owner, id: Int) {
    self.id = id
    self.title = title
    self.url = url
    self.user = user
  }
}
