//
//  TvShowsServices.swift
//  MovieApp
//
//  Created by João Victor Batista on 25/11/21.
//

import Foundation

class TvShowServices {
    
    let baseURL = "https://api.tvmaze.com/"
    
    func getShows(of page: Int, completionHandler: @escaping (_ response: [TvShow]?, _ error: Error?)  -> Void) {
        
        if let request = NetworkManager.shared.createRequest(with: baseURL + "shows?page=\(page)") {
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if (response as? HTTPURLResponse) != nil {
                    guard let data = data else { print(error!); return }
                    do {
                        let result = try JSONDecoder().decode([TvShow].self, from: data)
                        completionHandler(result, nil)
                    } catch {
                        print(error)
                        completionHandler(nil, error)
                    }
                }
            }.resume()
        }
    }
    
    func searchForShow(with query: String, completionHandler: @escaping (_ response: [TvShowSearchResult]?, _ error: Error?)  -> Void) {
        if let request = NetworkManager.shared.createRequest(with: baseURL + "search/shows?q=\(query)") {
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if (response as? HTTPURLResponse) != nil {
                    guard let data = data else { print(error!); return }
                    
                    do {
                        let result = try JSONDecoder().decode([TvShowSearchResult].self, from: data)
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

