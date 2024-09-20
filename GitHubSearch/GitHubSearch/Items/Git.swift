//
//  Git.swift
//  GitHubSearch
//
//  Created by Nikolay Scherbakov on 20.09.2024.
//

struct GitItems: Decodable {
  enum CodingKeys: String, CodingKey {
    case total = "total_count"
    case items = "items"
  }
  
  let total: Int
  let items: [GitItem]
}

struct GitItem: Decodable {
  enum CodingKeys: String, CodingKey {
    case name = "name"
    case libraryDescription = "description"
    case owner = "owner"
    case pageUrl = "html_url"
  }
  
  enum OwnerKeys: String, CodingKey {
    case avatarUrl = "avatar_url"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.pageUrL = try container.decode(String.self, forKey: .pageUrl)
    self.libraryDescription = try container.decodeIfPresent(String.self, forKey: .libraryDescription)
    
    let ownderContainer = try container.nestedContainer(
      keyedBy: OwnerKeys.self,
      forKey: .owner
    )
    
    let url = try ownderContainer.decode(String.self, forKey: .avatarUrl)
    self.url = url
  }
  
  let libraryDescription: String?
  let name: String
  let url: String?
  let pageUrL: String?
}
