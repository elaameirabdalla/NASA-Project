//  ViewController.swift
//  NasaSearch
//  Created by Abdalla Elaameir on 4/15/23.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: Fields
    
    // Outlets
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: "Search here")
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let apiHelper = APIHelper()
    var currentPage: Int = 1
    var lastSearched: String = ""
    
    var searchResults: [APIHelper.SearchResult] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // establish delegates/data source
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            apiHelper.getResults(search: text, pageNumber: currentPage, mediaType: "image", pageLimit: nil) { success, data in
                if let data = data, success {
                    self.searchResults = self.apiHelper.handleData(data: data)
                    self.currentPage += 1
                    self.lastSearched = text
                }
                else {
                    //error??
                }
            }
        }
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Will change to be custom cell to show wanted information
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultCell
        cell.tag = indexPath.row
        let resultForCell = searchResults[indexPath.row]
        
        
        cell.configureCell(href: resultForCell.href, title: resultForCell.title, description: resultForCell.description, index: indexPath.row)
        
        return cell
    }
        
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height + 100) {
            // Increment current page by 1, call api, APPEND to searchResults, reloadTableView
            apiHelper.getResults(search: lastSearched, pageNumber: currentPage, mediaType: "image", pageLimit: nil) { success, data in
                if let data = data, success {
                    self.searchResults.append(contentsOf: self.apiHelper.handleData(data: data))
                    self.currentPage += 1
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                else {
                    //error??
                }
            }
        }
    }
    
}

