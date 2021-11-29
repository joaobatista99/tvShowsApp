//
//  FavoriteTvShowViewModel.swift
//  TvApp
//
//  Created by João Victor Batista on 29/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class FavoriteTvShowViewModel {
    
    private var favoriteTvShowsRelay = BehaviorRelay<[TvShow]>(value: [])
    var favoriteTvShowsDriver: Driver<[TvShow]> {
        return favoriteTvShowsRelay.asObservable().asDriver(onErrorJustReturn: [])
    }
    
    func decodeFavoriteShows() {
        favoriteTvShowsRelay.accept(UserDefaultUtils.shared.decodeFavoriteShows() ?? [])
    }
    
    func removeShowFromFavorites(with id: Int) {
        
        if var decodedShows = UserDefaultUtils.shared.decodeFavoriteShows() {
            decodedShows.removeAll(where: {$0.id == id})
            self.encodeShowAndSave(with: decodedShows)
        } else {
            self.encodeShowAndSave(with: [])
        }
    }
    
    func encodeShowAndSave(with object: [TvShow]) {
        self.favoriteTvShowsRelay.accept(object)
        UserDefaultUtils.shared.encodeShowAndSave(with: object)
    }
    
    func orderTvShows() {
        guard !self.favoriteTvShowsRelay.value.isEmpty else {return}
        let orderedShows = favoriteTvShowsRelay.value.sorted { firstShow, secondShow in
            if let firstShowName = firstShow.name, let secondShowName = secondShow.name {
                return firstShowName < secondShowName
            }
            return false
        }
        favoriteTvShowsRelay.accept(orderedShows)
    }
    
}
