//
//  PeopleViewModel.swift
//  TvApp
//
//  Created by João Victor Batista on 29/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class PeopleListViewModel {
    
    let peopleService = PeopleServices()
    
    private let peopleRelay = BehaviorRelay<[Person]>(value: [])
    
    var peopleDriver: Driver<[Person]> {
        return peopleRelay.asObservable().asDriver(onErrorJustReturn: [])
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

    func getPeople(page: Int) {
        self.isLoadingRelay.accept(true)
        peopleService.getPeople(of: page) { [weak self] people, error in
            guard let self = self else {return}
            
            if error != nil {
                self.peopleRelay.accept([])
                self.isLoadingRelay.accept(false)
                print(error as Any)
            }
            
            if let people = people {
                self.peopleRelay.accept(people)
                self.isLoadingRelay.accept(false)
                self.statusRelay.accept(nil)
            } else {
                self.peopleRelay.accept([])
                self.isLoadingRelay.accept(false)
                self.statusRelay.accept("No person found")
            }
            
        }
    }
    
    func searchShows(with query: String) {
        self.isLoadingRelay.accept(true)
        self.peopleService.searchForPerson(with: query) { [weak self] searchResult, error in
            guard let self = self else {return}
            if error != nil {
                self.peopleRelay.accept([])
                self.isLoadingRelay.accept(false)
                self.statusRelay.accept("Network Error")
                print(error as Any)
            }
            
            if let searchResult = searchResult {
                if let allShows = searchResult.map({$0.person}) as? [Person] {
                    self.peopleRelay.accept(allShows)
                    if allShows.isEmpty {
                        self.statusRelay.accept("No person found")
                    }
                } else {
                    self.peopleRelay.accept([])
                    self.statusRelay.accept("No person found")
                }
                self.isLoadingRelay.accept(false)
            } else {
                self.statusRelay.accept("No person found")
            }
            
        }
    }
}
