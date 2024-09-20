//
//  GitListPresenter.swift
//  GitHubSearch
//
//  Created by Nikolay Scherbakov on 20.09.2024.
//

import Foundation

protocol GitList: AnyObject {
  func itemsCount() -> Int
  func itemAt(index: Int) -> GitItem
  func searchTextDidChange(_ text: String)
  var view: GitListView? {get set}
}

class GitListPresenter: GitList {
  private var gitItems: [GitItem] = []
  private let gitListInteractor: GitListInteractorProtocol = GitListInteractor()
  private let debouncer = Debouncer(delay: 1)
  weak var view: GitListView?
  
  func itemsCount() -> Int {
    gitItems.count
  }
  
  func itemAt(index: Int) -> GitItem {
    gitItems[index]
  }
  
  func searchTextDidChange(_ text: String) {
    gitItems = []
    view?.reloadData()
    gitListInteractor.cancel()
    
    guard !text.isEmpty else { return }
    
    debouncer.debounce { [weak self] in
      self?.gitListInteractor.search(query: text) { [weak self] items, error in
        guard let self else { return }
        guard error == nil else {
          DispatchQueue.main.async {
            self.view?.showError(error!)
          }
          return
        }
        
        if let items {
          self.gitItems = items.items
          DispatchQueue.main.async {
            self.view?.reloadData()
          }
        }
      }
    }
  }
}
