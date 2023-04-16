//
//  SearchResultCell.swift
//  NasaSearch
//
//  Created by Abdalla Elaameir on 4/15/23.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var rowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.rowImageView.image = nil
        self.titleLabel.text = ""
        self.descriptionLabel.text = ""
    }
    
    public func configureCell(href: String, title: String, description: String, index: Int) {
        titleLabel.text = title
        descriptionLabel.text = description
        
        guard let url = URL(string: href) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                if self?.tag == index {
                    self?.rowImageView.image = image
                }
            }
        }
        task.resume()
    }
}
