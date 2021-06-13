//
//  Repository.swift
//  Github Explorer
//
//  Created by inchurch on 12/06/21.
//

import Foundation

class Repository: Codable {
  var id: Int
  var name: String
  var full_name: String
  var owner: Owner
}
