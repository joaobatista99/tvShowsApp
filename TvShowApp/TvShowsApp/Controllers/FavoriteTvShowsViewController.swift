//
//  FavoriteTvShowsViewController.swift
//  TvApp
//
//  Created by João Victor Batista on 29/11/21.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteTvShowsViewController: UIViewController {

    @IBOutlet weak var favoriteTvShowTableView: UITableView!
    var favoriteTvShows: [TvShow] = []
    private let viewModel = FavoriteTvShowViewModel()
    let disposeBag = DisposeBag()
    private var isOrdered = false
    
    fileprivate lazy var orderButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "orderIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(orderFavoriteShows), for: .touchUpInside)
        button.tintColor = .darkGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupBinds()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isOrdered {
            self.viewModel.decodeFavoriteShows()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isOrdered = false
        self.orderButton.tintColor = .darkGray
        self.orderButton.isSelected = false
    }
    
    func setupNavigationBar() {
        self.title = "Favorites"
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: orderButton), animated: true)
    }
    
    @objc func orderFavoriteShows(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.tintColor = .systemBlue
            self.isOrdered = true
            self.viewModel.orderTvShows()
        } else {
            sender.tintColor = .darkGray
            self.isOrdered = false
            self.viewModel.decodeFavoriteShows()
        }
    }
        
    func setupBinds() {
        self.viewModel.favoriteTvShowsDriver.asObservable().subscribe(onNext: { [weak self] favoriteShows in
            guard let self = self else {return}
            self.favoriteTvShows = favoriteShows
            self.favoriteTvShowTableView.reloadData()
        }).disposed(by: disposeBag)
    }

    func setupTableView() {
        self.favoriteTvShowTableView.delegate = self
        self.favoriteTvShowTableView.dataSource = self
        self.favoriteTvShowTableView.allowsMultipleSelectionDuringEditing = false
        self.favoriteTvShowTableView.tableFooterView = UIView()
        self.favoriteTvShowTableView.estimatedRowHeight = 80
        self.favoriteTvShowTableView.allowsSelection = true
        self.favoriteTvShowTableView.register(UINib(nibName: String(describing: TvShowTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TvShowTableViewCell.self))
    }
}

extension FavoriteTvShowsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteTvShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TvShowTableViewCell.self), for: indexPath) as? TvShowTableViewCell else {
            return TvShowTableViewCell()
        }
        let tvShow = self.favoriteTvShows[indexPath.row]
        cell.update(with: TvShowViewModel(model: tvShow))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tvShow = self.favoriteTvShows[indexPath.row]
        let tvShowController = TvShowViewController.create(with: TvShowViewModel(model: tvShow))
        self.navigationController?.pushViewController(tvShowController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let showId = favoriteTvShows[indexPath.row].id {
                self.viewModel.removeShowFromFavorites(with: showId)
                self.orderButton.tintColor = .darkGray
            }
        }
    }
}
