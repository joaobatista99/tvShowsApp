//
//  TvShowEpisodeTableViewCell.swift
//  TvApp
//
//  Created by João Victor Batista on 28/11/21.
//

import UIKit

class TvShowEpisodeTableViewCell: UITableViewCell {

    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeSeasonAndNumberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func update(with viewModel: TvShowEpisodeViewModel) {
    
        if let episodeImageURL = viewModel.episodeImageURL {
            episodeImage.setImage(withURL: episodeImageURL.absoluteString, placeholderImage: viewModel.episodePlaceholderImage ?? UIImage())
        } else {
            episodeImage.image = viewModel.episodePlaceholderImage
        }
        
        self.episodeNameLabel.text = viewModel.episodeName
        self.episodeSeasonAndNumberLabel.text = "Episode \(viewModel.episodeNumber) - Season \(viewModel.episodeSeason)"
    }
    
}
