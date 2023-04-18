//
//  DataModels.swift
//  NasaSearch
//
//  Created by Abdalla Elaameir on 4/17/23.
//

import Foundation


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

// MARK: Data Model for Search results
public struct SearchResultViewModel {
    let href: String
    let title: String
    let description: String
    
    init(href: String, title: String, description: String) {
        self.href = href
        self.title = title
        self.description = description
    }
}
