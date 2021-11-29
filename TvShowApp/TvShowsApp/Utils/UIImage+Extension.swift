//
//  UIImage+Extension.swift
//  TvApp
//
//  Created by João Victor Batista on 28/11/21.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImage(withURL urlString: String, placeholderImage: UIImage) {
        image = placeholderImage
        
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let session = URLSession.shared

        let datatask = session.dataTask(with: request) { (data, response, error) in
            if let imgData = data {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage.init(data: imgData)
                }
            }
            
        }
        datatask.resume()
    }
}
