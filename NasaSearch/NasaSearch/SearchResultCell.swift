//
//  SearchResultCell.swift
//  NasaSearch
//
//  Created by Abdalla Elaameir on 4/15/23.
//

import UIKit
import Kingfisher

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
    
    public func configureCell(href: String, title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        // Retrieve and cache image using KingFisher library
        rowImageView.kf.setImage(with: URL(string: href))
    }
}
