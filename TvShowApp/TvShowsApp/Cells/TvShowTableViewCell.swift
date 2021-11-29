//
//  TvShowTableViewCell.swift
//  TvApp
//
//  Created by João Victor Batista on 28/11/21.
//

import UIKit

class TvShowTableViewCell: UITableViewCell {

    @IBOutlet weak var tvShowPosterImage: UIImageView!
    @IBOutlet weak var tvShowNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var viewModel: TvShowViewModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func enableFavoriteButton() {
        self.favoriteButton.isHidden = false
        self.favoriteButton.tintColor = .systemBlue
    }
    
    func update(with viewModel: TvShowViewModel) {
        self.viewModel = viewModel
        self.favoriteButton.isSelected = self.viewModel?.isShowFavorite ?? false
        
        if let posterImageURL = viewModel.posterImageURL {
            tvShowPosterImage.setImage(withURL: posterImageURL.absoluteString, placeholderImage: viewModel.posterPlaceholderImage ?? UIImage())
        } else {
            tvShowPosterImage.image = viewModel.posterPlaceholderImage
        }
        
        tvShowNameLabel.text = viewModel.tvShowName
        
    }
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if let isShowFavorite = self.viewModel?.isShowFavorite {
            self.viewModel?.isShowFavorite = !isShowFavorite
            
            if !isShowFavorite {
                self.viewModel?.setShowFavorite()
            } else {
                self.viewModel?.removeShowFromFavorites()
            }
        }
    }
}
