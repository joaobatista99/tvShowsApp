//
//  TvShowSearchResult.swift
//  TvApp
//
//  Created by João Victor Batista on 28/11/21.
//

import Foundation

struct TvShowSearchResult: Codable {
    let searchScore: Float?
    let show: TvShow?
    
    enum CodingKeys: String, CodingKey {
        case searchScore = "score"
        case show = "show"
    }
}
