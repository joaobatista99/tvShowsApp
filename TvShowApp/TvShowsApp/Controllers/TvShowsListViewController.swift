//
//  MoviesListViewController.swift
//  MovieApp
//
//  Created by João Victor Batista on 25/11/21.
//

import UIKit
import RxSwift
import RxCocoa

class TvShowsListViewController: UIViewController {

    @IBOutlet weak var tvShowsSearchBar: UISearchBar!
    @IBOutlet weak var tvShowsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private (set)var viewModel = TvShowsListViewModel()
    private let disposeBag = DisposeBag()
    private (set)var tvShows: [TvShow] = []
    private (set)var page = 0
    private (set)var shouldRefreshData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupTableView()
        self.setupSearchBar()
        self.setupTabBar()
        self.setupBinds()
        page += 1
        
    }
    
    func setupTableView() {
        self.tvShowsTableView.delegate = self
        self.tvShowsTableView.dataSource = self
        
        self.tvShowsTableView.tableFooterView = UIView()
        self.tvShowsTableView.estimatedRowHeight = 80
        self.tvShowsTableView.allowsSelection = true
        self.tvShowsTableView.register(UINib(nibName: String(describing: TvShowTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TvShowTableViewCell.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    func getData() {
        self.viewModel.getShows(page: self.page)
    }
    
    func setupTabBar() {
        self.tabBarItem = UITabBarItem(title: "Tv Shows", image: UIImage(named: "tvIcon"), selectedImage: UIImage(named: "selectedTvIcon"))
    }
    
    func setupNavigationBar() {
        self.title = "Tv Shows"
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "orderIcon"), style: .plain, target: self, action: #selector(orderTvShows)), animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = .darkGray
    }
    
    func setupSearchBar() {
        self.tvShowsSearchBar.delegate = self
        self.tvShowsSearchBar.placeholder = "Search for TV Shows!"
        self.tvShowsSearchBar.backgroundImage = UIImage()
    }
    
    func setupBinds() {
        self.viewModel.tvShowsDriver.asObservable().subscribe(onNext: { [weak self] tvShows in
            guard let self = self else {return}
            self.tvShows.append(contentsOf: tvShows)
            self.tvShowsTableView.reloadData()
            self.tvShowsSearchBar.endEditing(true)
        }).disposed(by: disposeBag)
        
        viewModel.isLoadingDriver.drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isLoadingDriver.asObservable().subscribe(onNext: {[weak self] isLoading in
            guard let self = self else {return}
            self.tvShowsTableView.isHidden = isLoading
            self.errorLabel.isHidden = isLoading
        }).disposed(by: disposeBag)
        
        viewModel.statusDriver.asObservable().subscribe(onNext: {[weak self] (message) in
            guard let self = self else {return}
            self.errorLabel.isHidden = message == nil
            self.tvShowsTableView.isHidden = message != nil
            self.errorLabel.text = message
        }).disposed(by: disposeBag)
        
        tvShowsSearchBar.rx.text.asDriver()
            .debounce(.milliseconds(500))
            .distinctUntilChanged()
            .drive(onNext: { [weak self] query in
                guard let self = self else {return}
                self.tvShows.removeAll()
                if query?.isEmpty == true {
                    self.page = 1
                    self.getData()
                    self.shouldRefreshData = false
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.navigationItem.rightBarButtonItem?.tintColor = .black
                } else {
                    self.shouldRefreshData = true
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    self.navigationItem.rightBarButtonItem?.tintColor = .lightGray
                    self.viewModel.searchShows(with: query ?? "")
                }
            })
            .disposed(by:disposeBag)
    }
    
    @objc func orderTvShows() {
        self.tvShows.removeAll()
        if shouldRefreshData {
            self.page = 1
            self.getData()
            self.navigationItem.rightBarButtonItem?.tintColor = .black
        } else {
            self.viewModel.orderTvShows()
            self.navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        }
        
        self.shouldRefreshData = !shouldRefreshData
    }
}

extension TvShowsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TvShowTableViewCell.self), for: indexPath) as? TvShowTableViewCell else {
            return TvShowTableViewCell()
        }
        guard !self.tvShows.isEmpty else { return TvShowTableViewCell()}
        let tvShow = self.tvShows[indexPath.row]
        cell.update(with: TvShowViewModel(model: tvShow))
        cell.enableFavoriteButton()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.item == self.tvShows.count - 1 && !shouldRefreshData {
            page += 1
            getData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tvShow = self.tvShows[indexPath.row]
        let tvShowController = TvShowViewController.create(with: TvShowViewModel(model: tvShow))
        self.navigationController?.pushViewController(tvShowController, animated: true)
    }
    
}

extension TvShowsListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
           searchBar.endEditing(true)
        }
    }
}
