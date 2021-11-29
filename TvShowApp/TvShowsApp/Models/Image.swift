//
//  TvShowImage.swift
//  MovieApp
//
//  Created by João Victor Batista on 25/11/21.
//

import Foundation

struct Image: Codable {
    let mediumImageURL: String?
    let originalImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case mediumImageURL = "medium"
        case originalImageURL = "original"
    }
}
