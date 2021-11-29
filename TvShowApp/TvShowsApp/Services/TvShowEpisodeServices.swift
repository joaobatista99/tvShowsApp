//
//  TvShowEpisodeServices.swift
//  TvApp
//
//  Created by João Victor Batista on 28/11/21.
//

import Foundation

class TvShowEpisodeServices {
    
    let baseURL = "https://api.tvmaze.com/shows/"
    
    func getEpisodes(of show: Int, completionHandler: @escaping (_ response: [TvShowEpisode]?, _ error: Error?)  -> Void) {
        
        if let request = NetworkManager.shared.createRequest(with: baseURL + "\(show)/episodes") {
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if (response as? HTTPURLResponse) != nil {
                    guard let data = data else { print(error!); return }
                    do {
                        let result = try JSONDecoder().decode([TvShowEpisode].self, from: data)
                        completionHandler(result, nil)
                    } catch {
                        print(error)
                        completionHandler(nil, error)
                    }
                }
            }.resume()
        }
    }
    
}

