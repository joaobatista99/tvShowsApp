//
//  PeopleTableViewCell.swift
//  TvApp
//
//  Created by João Victor Batista on 29/11/21.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var peopleImage: UIImageView!
    @IBOutlet weak var peopleName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with viewModel: PeopleViewModel) {
        
        if let posterImageURL = viewModel.posterImageURL {
            peopleImage.setImage(withURL: posterImageURL.absoluteString, placeholderImage: viewModel.posterPlaceholderImage ?? UIImage())
        } else {
            peopleImage.image = viewModel.posterPlaceholderImage
        }
    
        peopleName.text = viewModel.peopleName
    }
    
}
