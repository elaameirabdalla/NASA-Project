//  ViewController.swift
//  NasaSearch
//  Created by Abdalla Elaameir on 4/15/23.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: Fields
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: "Search here")
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // var results: [***] = []
        
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // establish delegates/data source
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Should also clear currently presented results for new results to load in
        if let text = textField.text, !text.isEmpty {
            // Call API here with text
        }
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // arbitrary number for now, will change to be based on number of search results per page
        
        // return results.count
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Will change to be custom cell to show wanted information
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // handle pagination??
    }
    
}

