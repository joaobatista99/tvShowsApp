//
//  TvShowEpisodeViewModel.swift
//  TvApp
//
//  Created by João Victor Batista on 28/11/21.
//

import Foundation
import UIKit

class TvShowEpisodeViewModel {
    var episodeName: String = ""
    var episodeSeason: Int = 0
    var episodeNumber: Int = 0
    var episodeSummary: String = ""
    var episodeImageURL: URL?
    let episodePlaceholderImage = UIImage(named: "tvShowPosterPlaceholder")
    
    init(with model: TvShowEpisode) {
        if let episodeName = model.name {
            self.episodeName = episodeName
        }
        
        if let season = model.season {
            self.episodeSeason = season
        }
        
        if let number = model.number {
            self.episodeNumber = number
        }
        
        if let summary = model.summary?.stripOutHtml() {
            self.episodeSummary = summary
        }
        
        if let posterPath = model.image?.mediumImageURL {
            self.episodeImageURL = URL(string: posterPath)
        }
    }
}
