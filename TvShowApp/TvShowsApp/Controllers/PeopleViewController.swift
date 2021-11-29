//
//  PeopleViewController.swift
//  TvApp
//
//  Created by João Victor Batista on 29/11/21.
//

import UIKit
import RxCocoa
import RxSwift

class PeopleViewController: UIViewController {

    @IBOutlet weak var peopleTableView: UITableView!
    @IBOutlet weak var peopleSearchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private (set)var viewModel = PeopleListViewModel()
    private (set)var page = 0
    private let disposeBag = DisposeBag()
    private (set)var people: [Person] = []
    private (set)var shouldRefreshData = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupSearchBar()
        self.setupTableView()
        self.setupBinds()
        page += 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    func getData() {
        self.viewModel.getPeople(page: self.page)
    }
    
    func setupNavigationBar() {
        self.title = "People"
    }
    
    func setupSearchBar() {
        self.peopleSearchBar.delegate = self
        self.peopleSearchBar.placeholder = "Search for actors and actresses"
        self.peopleSearchBar.backgroundImage = UIImage()
    }
    
    func setupTableView() {
        self.peopleTableView.delegate = self
        self.peopleTableView.dataSource = self
        
        self.peopleTableView.tableFooterView = UIView()
        self.peopleTableView.estimatedRowHeight = 80
        self.peopleTableView.allowsSelection = true
        self.peopleTableView.register(UINib(nibName: String(describing: PeopleTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PeopleTableViewCell.self))
    }
    
    func setupBinds() {
        self.viewModel.peopleDriver.asObservable().subscribe(onNext: { [weak self] people in
            guard let self = self else {return}
            self.people.append(contentsOf: people)
            self.peopleTableView.reloadData()
            self.peopleSearchBar.endEditing(true)
        }).disposed(by: disposeBag)
        
        viewModel.isLoadingDriver.drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isLoadingDriver.asObservable().subscribe(onNext: {[weak self] isLoading in
            guard let self = self else {return}
            self.peopleTableView.isHidden = isLoading
            self.errorLabel.isHidden = isLoading
        }).disposed(by: disposeBag)
        
        viewModel.statusDriver.asObservable().subscribe(onNext: {[weak self] (message) in
            guard let self = self else {return}
            self.errorLabel.isHidden = message == nil
            self.peopleTableView.isHidden = message != nil
            self.errorLabel.text = message
        }).disposed(by: disposeBag)
        
        peopleSearchBar.rx.text.asDriver()
            .debounce(.milliseconds(500))
            .distinctUntilChanged()
            .drive(onNext: { [weak self] query in
                guard let self = self else {return}
                self.people.removeAll()
                if query?.isEmpty == true {
                    self.page = 1
                    self.getData()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.navigationItem.rightBarButtonItem?.tintColor = .black
                    self.shouldRefreshData = false
                } else {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    self.navigationItem.rightBarButtonItem?.tintColor = .lightGray
                    self.shouldRefreshData = true
                    self.viewModel.searchShows(with: query ?? "")
                }
            })
            .disposed(by:disposeBag)
    }
}

extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PeopleTableViewCell.self), for: indexPath) as? PeopleTableViewCell else {
            return PeopleTableViewCell()
        }
        guard !self.people.isEmpty else { return PeopleTableViewCell()}
        let person = self.people[indexPath.row]
        cell.update(with: PeopleViewModel(model: person))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.item == self.people.count - 1 && !shouldRefreshData {
            page += 1
            getData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}

extension PeopleViewController: UISearchBarDelegate {
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
