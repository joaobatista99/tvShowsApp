//
//  UserDefaultUtils.swift
//  TvApp
//
//  Created by João Victor Batista on 29/11/21.
//

import Foundation

class UserDefaultUtils {
    static let shared = UserDefaultUtils()
    
    func encodeShowAndSave(with object: [TvShow]) {
        let jsonEncoder = JSONEncoder()
        if let encoded = try? jsonEncoder.encode(object) {
            UserDefaults.standard.set(encoded, forKey: "favoriteShows")
        }
    }
    
    func decodeFavoriteShows() -> [TvShow]? {
        let jsonDecoder = JSONDecoder()
        if let favoriteShows = UserDefaults.standard.object(forKey: "favoriteShows") as? Data,
           let decodedShows = try? jsonDecoder.decode(Array.self, from: favoriteShows) as [TvShow] {
            return decodedShows
        }
        return nil
    }

}
