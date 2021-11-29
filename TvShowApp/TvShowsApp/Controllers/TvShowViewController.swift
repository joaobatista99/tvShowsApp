//
//  TvShowViewController.swift
//  TvApp
//
//  Created by João Victor Batista on 28/11/21.
//

import UIKit
import RxSwift
import RxCocoa

class TvShowViewController: UIViewController {

    @IBOutlet weak var tvShowPosterImage: UIImageView!
    @IBOutlet weak var tvShowEpisodesTableView: UITableView!
    @IBOutlet weak var tvShowNameLabel: UILabel!
    @IBOutlet weak var tvShowGenreLabel: UILabel!
    @IBOutlet weak var tvShowAirDaysLabel: UILabel!
    @IBOutlet weak var tvShowAirTimeLabel: UILabel!
    @IBOutlet weak var tvShowSummaryLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var viewModel: TvShowViewModel!
    private let disposeBag = DisposeBag()
    private var episodes: [[TvShowEpisode]] = []

    let screenHeight = UIScreen().bounds.height
    var scrollViewContentHeight: CGFloat = .zero
    
    class func create(with viewModel: TvShowViewModel) -> TvShowViewController {
        let tvShowController = TvShowViewController()
        tvShowController.viewModel = viewModel
        return tvShowController
    }
    
    fileprivate var episodesTableViewHeader: UIView = {
        let view = UIView()
        let episodesLabel = UILabel()
        episodesLabel.text = "Episodes"
        episodesLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        view.addSubview(episodesLabel)
        episodesLabel.translatesAutoresizingMaskIntoConstraints = false
        episodesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        episodesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupContent()
        self.setupTableView()
        self.setupBinds()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.getEpisodes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollViewContentHeight = scrollView.contentSize.height
    }
    
    func setupContent() {
        self.tvShowNameLabel.text = viewModel.tvShowName
        self.tvShowGenreLabel.text = viewModel.genre
        self.tvShowSummaryLabel.text = viewModel.summary
        self.tvShowAirTimeLabel.text = viewModel.airTime
        if let posterImageURL = viewModel.posterImageURL {
            tvShowPosterImage.setImage(withURL: posterImageURL.absoluteString, placeholderImage: viewModel.posterPlaceholderImage ?? UIImage())
        } else {
            tvShowPosterImage.image = viewModel.posterPlaceholderImage
        }
    }
    
    func setupTableView() {
        self.tvShowEpisodesTableView.delegate = self
        self.tvShowEpisodesTableView.dataSource = self
        self.tvShowEpisodesTableView.rowHeight = UITableView.automaticDimension
        self.tvShowEpisodesTableView.tableFooterView = UIView()
        self.tvShowEpisodesTableView.allowsSelection = true
        self.tvShowEpisodesTableView.register(UINib(nibName: String(describing: TvShowEpisodeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TvShowEpisodeTableViewCell.self))

    }
    
    func setupBinds() {
        self.viewModel.episodesDriver.asObservable().subscribe(onNext: { [weak self] episodes in
            guard let self = self else {return}
            self.episodes = episodes
            if !episodes.isEmpty {
                self.tvShowEpisodesTableView.reloadData()
            }
            
        }).disposed(by: disposeBag)
    }
}

extension TvShowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Season " + "\(section+1)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TvShowEpisodeTableViewCell.self), for: indexPath) as? TvShowEpisodeTableViewCell else {
            return TvShowEpisodeTableViewCell()
        }
        
        let episode = self.episodes[indexPath.section][indexPath.row]
        cell.update(with: TvShowEpisodeViewModel(with: episode))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.section][indexPath.row]
        let episodeController = EpisodeViewController.create(with: TvShowEpisodeViewModel(with: episode))
        self.navigationController?.pushViewController(episodeController, animated: true)
        
    }

}

