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
    
    // MARK: Structs representing data to be decoded from response
    
    // Root as highest level
    struct Root: Codable {
        enum CodingKeys: String, CodingKey {
            case collection
        }
        let collection: Collection
    }
    
    // Collection field that contains an array of 'SearchItems'
    struct Collection: Codable {
        enum CodingKeys: String, CodingKey {
            case items
        }
        let items: [Item]
    }
    
    // SearchItem struct representing each search result, containing the data (array of search-related info) and links (array containing image information)
    struct Item: Codable {
        enum CodingKeys: String, CodingKey {
            case data
            case links
        }
        let data: [SearchInfo]
        let links: [LinksInfo]
    }
    
    struct SearchInfo: Codable {
        enum CodingKeys: String, CodingKey {
            case title
            case description
        }
        let title: String
        let description: String
    }
    
    struct LinksInfo: Codable {
        enum CodingKeys: String, CodingKey {
            case href
        }
        let href: String
    }
    
    // Data model for Search results
    public struct SearchResult {
        let href: String
        let title: String
        let description: String
        
        init(href: String, title: String, description: String) {
            self.href = href
            self.title = title
            self.description = description
        }
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
    public func handleData(data: Data) -> [SearchResult] {
        let decoder = JSONDecoder()
        let root = try? decoder.decode(Root.self, from: data)
        
        guard let root = root else {
            return []
        }
        let results = root.collection.items.map {
            return SearchResult(href: $0.links[0].href, title: $0.data[0].title, description: $0.data[0].description)
        }
        
        return results
    }
    
}
