//
//  Album.swift
//  weecare-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

struct Album: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case title
        case artist
        case releaseDate = "release_date"
    }
    
    var id: Int
    var name: String
    var image: String
    var title: String
    var artist: String
    var releaseDate: Date
}
