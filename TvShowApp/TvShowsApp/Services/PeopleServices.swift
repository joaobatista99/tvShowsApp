//
//  PeopleService.swift
//  TvApp
//
//  Created by João Victor Batista on 29/11/21.
//

import Foundation

class PeopleServices {
    let baseURL = "https://api.tvmaze.com/"
    
    func getPeople(of page: Int, completionHandler: @escaping (_ response: [Person]?, _ error: Error?)  -> Void) {
        
        if let request = NetworkManager.shared.createRequest(with: baseURL + "people?page=\(page)") {
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if (response as? HTTPURLResponse) != nil {
                    guard let data = data else { print(error!); return }
                    do {
                        let result = try JSONDecoder().decode([Person].self, from: data)
                        completionHandler(result, nil)
                    } catch {
                        print(error)
                        completionHandler(nil, error)
                    }
                }
            }.resume()
        }
    }
    
    func searchForPerson(with query: String, completionHandler: @escaping (_ response: [PersonSearchResult]?, _ error: Error?)  -> Void) {
        if let request = NetworkManager.shared.createRequest(with: baseURL + "search/people?q=\(query)") {
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if (response as? HTTPURLResponse) != nil {
                    guard let data = data else { print(error!); return }
                    
                    do {
                        let result = try JSONDecoder().decode([PersonSearchResult].self, from: data)
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
