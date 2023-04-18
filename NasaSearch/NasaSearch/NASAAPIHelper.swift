//
//  APIHelper.swift
//  NasaSearch
//
//  Created by Abdalla Elaameir on 4/15/23.
//

import Foundation
import UIKit

class NASAAPIHelper {
    
    enum Constant {
        static let nasaImageSearchEndpoint = "https://images-api.nasa.gov/search?"
    }
    
    public init() {}
    
    // MARK: Functions
    
    // Build endpoint url and call NASA Image Search API
    public func getNASAImageSearchResults(search: String, pageNumber: Int, mediaType: String, pageLimit: Int?,
                           completion: @escaping (_ success: Bool, _ data: Data?) -> Void) {
        
        // Sets page size constraint if passed in
        var pageSizeParameter = ""
        if let pageLimit = pageLimit {
            pageSizeParameter = "page_size=\(pageLimit)"
        }
        
        let imageEndpoint = Constant.nasaImageSearchEndpoint + "q=\(search)&page=\(pageNumber)&media_type=\(mediaType)" + pageSizeParameter
        
        let url = URL(string: imageEndpoint)
        
        guard let url = url else {
            return
        }
        
        // Calls endpoint
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(true, data)
            }
            else {
                completion(false, nil)
            }
        }
        task.resume()
    }
    
    // Transforms data into array of SearchResult
    public func handleData(data: Data) -> [SearchResultViewModel] {
        let decoder = JSONDecoder()
        let root = try? decoder.decode(Root.self, from: data)
        
        guard let root = root else {
            return []
        }
        let results = root.collection.items.map {
            return SearchResultViewModel(href: $0.links[0].href, title: $0.data[0].title, description: $0.data[0].description)
        }
        
        return results
    }
    
}
