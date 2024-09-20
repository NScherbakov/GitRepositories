//
//  ViewController.swift
//  GitHubSearch
//
//  Created by Nikolay Scherbakov on 20.09.2024.
//

import UIKit

protocol GitListView: AnyObject {
  func showError(_ error: Error)
  func reloadData()
  func showLoader()
  func hideLoader()
}

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  private let presenter: GitList = GitListPresenter()
  private var router: GitListRouting = GitListRouter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTitle()
    registerCell()
    configureRouter()
    configurePresenter()
    
    /* Just For Rude Stupid Tesing For Finall Result */
    DispatchQueue.main.async {
      self.searchBar.text = "Tetris+language:swift"
      self.searchBar(self.searchBar, textDidChange: self.searchBar.text!)
    }
    /* Just For Rude Stupid Tesing For Finall Result */
  }
}

// MARK: - GitListView

extension ViewController: GitListView {
  func showError(_ error: Error) {
    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  func reloadData() {
    tableView.reloadData()
  }
  
  func showLoader() {
    // TO DO
  }
  
  func hideLoader() {
    // TO DO
  }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    presenter.searchTextDidChange(searchText)
  }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter.itemsCount()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GitItemCell", for: indexPath) as? GitItemCell else { return UITableViewCell() }
    cell.upate(with: presenter.itemAt(index: indexPath.row))
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = presenter.itemAt(index: indexPath.row)
    router.moveToDetail(with: item.pageUrL)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}

// MARK: - Private

private extension ViewController {
  func configurePresenter() {
    presenter.view = self
  }
  
  func registerCell() {
    tableView.register(UINib(nibName: "GitItemCell", bundle: nil), forCellReuseIdentifier: "GitItemCell")
  }
  
  func configureTitle() {
    navigationItem.title = "Search For Repo"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func configureRouter() {
    router.navigation = navigationController
  }
}

