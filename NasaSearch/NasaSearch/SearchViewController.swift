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
    
    // Variables
    let apiHelper = NASAAPIHelper()
    var currentPage: Int = 1
    var lastSearched: String = ""
    
    var searchResults: [SearchResultViewModel] = [] {
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
        tableView.accessibilityIdentifier = "ResultsTable"
        textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Calls api to retrieve search results for searched text when return button is pressed -
        // will NOT call for empty text
        if let text = textField.text, !text.isEmpty {
            currentPage = 1
            apiHelper.getNASAImageSearchResults(search: text, pageNumber: currentPage, mediaType: "image", pageLimit: nil) { success, data in
                if let data = data, success {
                    // Transform data into expected structure [SearchResultViewModel] to load into TableView
                    self.searchResults = self.apiHelper.handleData(data: data)
                    
                    // Shows alert if no results found
                    if self.searchResults.isEmpty {
                        self.showAlert()
                    }
                    // Keep track of next page to be searched as well as last searched term for pagination
                    self.lastSearched = text
                }
                // Presents alert on failure case (service error)
                else if !success, data == nil {
                    self.showAlert()
                }
            }
        }
        return true
    }
    
    func showAlert() {
        let alertVC = UIAlertController(title: "Error", message: "No results found. Please try again or enter a different search.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel))
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Custom cell to display image, title, and description per searchResult
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultCell
        
        // Configure cell based on coorelating searchResult at the same index
        cell.searchResultViewModel = searchResults[indexPath.row]
        
        return cell
    }
    
    // Handles pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let dragThreshold = scrollView.contentSize.height + 100
        let distancedDragged = scrollView.contentOffset.y + scrollView.frame.size.height
        
        // if user scrolls beyond last cell (threshold), then call pull results for next page and load
        if distancedDragged > dragThreshold {
            // Increment current page by 1, call api, APPEND to searchResults, reloadTableView
            currentPage += 1
            apiHelper.getNASAImageSearchResults(search: lastSearched, pageNumber: currentPage, mediaType: "image", pageLimit: nil) { success, data in
                if let data = data, success {
                    self.searchResults.append(contentsOf: self.apiHelper.handleData(data: data))
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

