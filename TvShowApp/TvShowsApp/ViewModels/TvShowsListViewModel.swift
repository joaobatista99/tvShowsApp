//
//  MoviesListViewModel.swift
//  MovieApp
//
//  Created by João Victor Batista on 25/11/21.
//

import Foundation
import RxCocoa
import RxSwift

class TvShowsListViewModel {
    
    let tvShowService = TvShowServices()
    
    private let tvShowsRelay = BehaviorRelay<[TvShow]>(value: [])
    
    var tvShowsDriver: Driver<[TvShow]> {
        return tvShowsRelay.asObservable().asDriver(onErrorJustReturn: [])
    }
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    var isLoadingDriver: Driver<Bool> {
        return isLoadingRelay.asObservable().asDriver(onErrorJustReturn: false)
    }
    
    private let statusRelay = BehaviorRelay<String?>(value: nil)
    
    var statusDriver: Driver<String?> {
        return statusRelay
            .asObservable().asDriver(onErrorJustReturn: nil)
    }
    
    func getShows(page: Int) {
        self.isLoadingRelay.accept(true)
        tvShowService.getShows(of: page) { [weak self] tvShows, error in
            guard let self = self else {return}
            
            if error != nil {
                self.tvShowsRelay.accept([])
                self.isLoadingRelay.accept(false)
                print(error as Any)
            }
            
            if let tvShows = tvShows {
                self.tvShowsRelay.accept(tvShows)
                self.isLoadingRelay.accept(false)
                self.statusRelay.accept(nil)
            } else {
                self.tvShowsRelay.accept([])
                self.isLoadingRelay.accept(false)
                self.statusRelay.accept("No Tv Shows found")
            }
            
        }
    }
    
    func searchShows(with query: String) {
        self.isLoadingRelay.accept(true)
        self.tvShowService.searchForShow(with: query) { [weak self] searchResult, error in
            guard let self = self else {return}
            if error != nil {
                self.tvShowsRelay.accept([])
                self.isLoadingRelay.accept(false)
                self.statusRelay.accept("Network Error")
                print(error as Any)
            }
            
            if let searchResult = searchResult {
                if let allShows = searchResult.map({$0.show}) as? [TvShow] {
                    self.tvShowsRelay.accept(allShows)
                    if allShows.isEmpty {
                        self.statusRelay.accept("No Tv Shows found")
                    }
                } else {
                    self.tvShowsRelay.accept([])
                    self.statusRelay.accept("No Tv Shows found")
                }
                self.isLoadingRelay.accept(false)
            } else {
                self.statusRelay.accept("No Tv Shows found")
            }
            
        }
    }
    
    
    func orderTvShows() {
        let orderedShows = tvShowsRelay.value.sorted { firstShow, secondShow in
            if let firstShowName = firstShow.name, let secondShowName = secondShow.name {
                return firstShowName < secondShowName
            }
            return false
        }
        self.tvShowsRelay.accept(orderedShows)
    }
}
