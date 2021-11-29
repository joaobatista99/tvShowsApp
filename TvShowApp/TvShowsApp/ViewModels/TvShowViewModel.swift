//
//  TvShowTableViewCellViewModel.swift
//  TvApp
//
//  Created by João Victor Batista on 28/11/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TvShowViewModel {
    
    var model: TvShow!
    var showId: Int = 0
    var tvShowName: String = ""
    var posterImageURL: URL?
    let posterPlaceholderImage = UIImage(named: "tvShowPosterPlaceholder")
    var genre: String = ""
    var airDays: String = ""
    var airTime: String = ""
    var summary: String = ""
    var lastSeason: Int = 0
    var isShowFavorite: Bool = false
    
    let tvShowEpisodeService = TvShowEpisodeServices()

    private let episodesRelay = BehaviorRelay<[[TvShowEpisode]]>(value: [])
    
    var episodesDriver: Driver<[[TvShowEpisode]]> {
        return episodesRelay.asObservable().asDriver(onErrorJustReturn: [])
    }
    
    // MARK: - Init
    init(model: TvShow) {
        self.model = model
        
        if let tvShowName = model.name {
            self.tvShowName = tvShowName
        }
        
        if let posterPath = model.posterImages?.mediumImageURL {
            self.posterImageURL = URL(string: posterPath)
        }
        
        if let genres = model.genres {
            self.genre = genres.joined(separator: ", ")
        }
        
        if let summary = model.summary {
            self.summary = summary.stripOutHtml() ?? ""
        }
        
        if let airDays = model.schedule?.airDays {
            self.airDays = airDays.joined(separator: ", ")
        }
        
        if let airTime = model.schedule?.airTime {
            self.airTime = airTime
        }
        
        if let id = model.id {
            self.showId = id
        }
        
        if let decodedShows = self.decodeFavoriteShows() {
            self.isShowFavorite = decodedShows.contains(where: {$0.id == self.model.id})
        }
            
    }
    
    func getEpisodes() {
        self.tvShowEpisodeService.getEpisodes(of: self.showId) { [weak self] episodes, error in
            guard let self = self else {return}
            if error != nil {
                self.episodesRelay.accept([])
                print(error as Any)
            }
            
            if let episodes = episodes {
                
                var episodesDividedBySeason = Array(Dictionary(grouping: episodes){$0.season}.values)
                episodesDividedBySeason.sort(by: { season, secondSeason in
                    if let seasonNumber = season.first?.season, let secondSeasonNumber = secondSeason.first?.season {
                        return seasonNumber < secondSeasonNumber
                    }
                    return false
                })
                self.episodesRelay.accept(episodesDividedBySeason)
                if let lastSeason = episodes.last?.season {
                    self.lastSeason = lastSeason
                }
            }
        }
    }
    
    func setShowFavorite() {
        self.isShowFavorite = true
        
        if var decodedShows = self.decodeFavoriteShows() {
            decodedShows.append(self.model)
            self.encodeShowAndSave(with: decodedShows)
        } else {
            self.encodeShowAndSave(with: [self.model])
        }
    }
    
    func removeShowFromFavorites() {
        self.isShowFavorite = false
        
        if var decodedShows = self.decodeFavoriteShows() {
            decodedShows.removeAll(where: {$0.id == model.id})
            self.encodeShowAndSave(with: decodedShows)
        } else {
            self.encodeShowAndSave(with: [])
        }
    }
    
    func encodeShowAndSave(with object: [TvShow]) {
        UserDefaultUtils.shared.encodeShowAndSave(with: object)
    }
    
    func decodeFavoriteShows() -> [TvShow]? {
        return UserDefaultUtils.shared.decodeFavoriteShows()
    }
    
}
