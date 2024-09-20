//
//  GitItemCell.swift
//  GitHubSearch
//
//  Created by Nikolay Scherbakov on 20.09.2024.
//

import UIKit

class GitItemCell: UITableViewCell {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  @IBOutlet private weak var avatarImageView: UIImageView!
  
  private var dataTask: URLSessionDataTask?

  override public func prepareForReuse() {
    super.prepareForReuse()
    dataTask?.cancel()
  }
  
  func upate(with item: GitItem) {
    titleLabel.text = item.name
    descriptionLabel.text = item.libraryDescription
    if let stringUrl = item.url, let imageUrl = URL(string: stringUrl) {
      downloadImage(by: imageUrl)
    }
  }
  
  private func downloadImage(by url: URL) {
    dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data else { return }
      
      DispatchQueue.main.async() {
        self.avatarImageView.image = UIImage(data: data)
      }
    }
    dataTask?.resume()
  }
}
