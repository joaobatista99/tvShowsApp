//
//  EpisodeViewController.swift
//  TvApp
//
//  Created by João Victor Batista on 28/11/21.
//

import UIKit

class EpisodeViewController: UIViewController {

    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeSeasonAndNumberLabel: UILabel!
    @IBOutlet weak var episodeSummaryLabel: UILabel!
    
    private var viewModel: TvShowEpisodeViewModel!
    
    class func create(with viewModel: TvShowEpisodeViewModel) -> EpisodeViewController {
        let episodeController = EpisodeViewController()
        episodeController.viewModel = viewModel
        return episodeController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupContent()
    }

    func setupContent() {
        if let episodeImageURL = viewModel.episodeImageURL {
            episodeImage.setImage(withURL: episodeImageURL.absoluteString, placeholderImage: viewModel.episodePlaceholderImage ?? UIImage())
        } else {
            episodeImage.image = viewModel.episodePlaceholderImage
        }
        
        self.episodeNameLabel.text = viewModel.episodeName
        self.episodeSummaryLabel.text = viewModel.episodeSummary
        self.episodeSeasonAndNumberLabel.text = "Episode \(viewModel.episodeNumber) - Season \(viewModel.episodeSeason)"
    }
}
