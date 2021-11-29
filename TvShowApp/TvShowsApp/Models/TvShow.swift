//
//  TvShow.swift
//  MovieApp
//
//  Created by João Victor Batista on 25/11/21.
//

import Foundation

struct TvShow: Codable {
    let id: Int?
    let name: String?
    let posterImages: Image?
    let schedule: TvShowSchedule?
    let genres: [String]?
    let summary: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case posterImages = "image"
        case schedule = "schedule"
        case genres = "genres"
        case summary = "summary"
    }
}

struct TvShowSchedule: Codable {
    let airTime: String?
    let airDays: [String]?
    
    enum CodingKeys: String, CodingKey {
        case airTime = "time"
        case airDays = "days"
    }
}
