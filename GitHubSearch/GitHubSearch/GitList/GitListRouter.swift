//
//  GitListRouter.swift
//  GitHubSearch
//
//  Created by Nikolay Scherbakov on 20.09.2024.
//

import Foundation
import UIKit

protocol GitListRouting {
  func moveToDetail(with stringUrl: String?)
  var navigation: UINavigationController? { get set }
}

class GitListRouter: GitListRouting {
  weak var navigation: UINavigationController?
  
  func moveToDetail(with stringUrl: String?) {
    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
    let detail = storyBoard.instantiateViewController(withIdentifier: "DetailRepositoryInfo") as! DetailRepositoryInfo
    detail.stringURL = stringUrl
    navigation?.pushViewController(detail, animated: true)
  }
}
