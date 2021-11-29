//
//  NetworkManager.swift
//  MovieApp
//
//  Created by João Victor Batista on 25/11/21.
//

import Foundation


class NetworkManager {
    
    static let shared = NetworkManager()
    
    func createRequest(with url: String) -> URLRequest? {
        if let url = URL(string: url)  {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            //HTTP Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }
        return nil
    }
}
