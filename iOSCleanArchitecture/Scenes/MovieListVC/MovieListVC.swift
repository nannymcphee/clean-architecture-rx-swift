//
//  MovieListVC.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit
import DNDomain
import RxSwift
import RxCocoa

class MovieListVC: RxBaseVC<MovieListVM> {
    // MARK: - IBOutlets
    @IBOutlet weak var tbMovieList: MoviesRxTableView!
    
    // MARK: - Variables
    private let searchController = UISearchController()
    private let viewDidLoadTrigger = PublishSubject<Void>()
    private let viewWillAppearTrigger = PublishSubject<Void>()
    
    // MARK: - Overrides
    override func viewDidLoad() {
        setUpUI()
        bindingUI()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearTrigger.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.searchBar.resignFirstResponder()
    }
    
    override func bindViewModel() {
        let input = Input(viewDidLoadTrigger: viewDidLoadTrigger,
                          refreshTrigger: refreshTrigger,
                          viewWillAppearTrigger: viewWillAppearTrigger,
                          movieSelectTrigger: tbMovieList.movieSelectTrigger,
                          favoriteTrigger: tbMovieList.favoriteTrigger,
                          searchText: searchController.searchBar.rx.text.asObservable())
        let output = viewModel.transform(input: input)
        
        output.movieSections
            .drive(tbMovieList.rx.items(dataSource: tbMovieList.rxDataSource))
            .disposed(by: disposeBag)
        
        output.movieSections
            .skip(1)
            .map { $0.isEmpty || $0.contains(where: { $0.items.isEmpty }) }
            .drive(with: self, onNext: { vc, isEmpty in
                guard isEmpty else {
                    return vc.tbMovieList.removeEmptyView()
                }
                
                let message = vc.viewModel.isSearching ? "No results" : "No data"
                vc.tbMovieList.showEmptyView(msg: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.loadingIndicator
            .do(onNext: { [weak self] indicator in
                if !indicator.boolValue {
                    self?.refreshControl.endRefreshing()
                }
            })
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
        
        viewModel.errorTracker
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .drive(rx.error)
            .disposed(by: disposeBag)
        
        viewDidLoadTrigger.onNext(())
    }

    // MARK: - Private functions
    private func setUpUI() {
        setUpNavigationBar()
        initRefreshControl()
        tbMovieList.refreshControl = refreshControl
    }
    
    private func setUpNavigationBar() {
        title = "Movie List"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func bindingUI() {
        searchController.searchBar.rx
            .cancelButtonClicked
            .subscribe(with: self, onNext: { vc, _ in
                guard !vc.searchController.searchBar.isFirstResponder else { return }
                vc.searchController.searchBar.text = ""
                vc.searchController.searchBar.searchTextField.sendActions(for: .editingChanged)
            })
            .disposed(by: disposeBag)
    }
}
