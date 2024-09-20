//
//  DetailRepositoryInfo.swift
//  GitHubSearch
//
//  Created by Nikolay Scherbakov on 20.09.2024.
//

import UIKit
import WebKit

class DetailRepositoryInfo: UIViewController {
  @IBOutlet private weak var webView: WKWebView!
  
  var stringURL: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadUrl()
  }
  
  private func loadUrl() {
    guard let stringURL, let url = URL(string: stringURL) else { return }
    webView.load(URLRequest(url: url))
  }
}
