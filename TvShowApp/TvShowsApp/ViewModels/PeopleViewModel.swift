//
//  PeopleViewModel.swift
//  TvApp
//
//  Created by João Victor Batista on 29/11/21.
//

import Foundation
import UIKit

class PeopleViewModel {
    var peopleName: String = ""
    var posterImageURL: URL?
    let posterPlaceholderImage = UIImage(named: "tvShowPosterPlaceholder")

    init(model: Person) {
        
        if let posterPath = model.image?.mediumImageURL {
            self.posterImageURL = URL(string: posterPath)
        }
        
        if let name = model.name {
            self.peopleName = name
        }
        
    }
}
