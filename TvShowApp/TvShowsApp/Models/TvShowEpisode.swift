//
//  TvShowEpisode.swift
//  MovieApp
//
//  Created by João Victor Batista on 25/11/21.
//

import Foundation

struct TvShowEpisode: Codable {
    let id: Int?
    let name: String?
    let season: Int?
    let number: Int?
    let summary: String?
    let image: Image?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case season = "season"
        case number = "number"
        case summary = "summary"
        case image = "image"
    }
}
