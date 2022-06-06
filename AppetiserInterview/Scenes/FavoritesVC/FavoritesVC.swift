//
//  FavoritesVC.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritesVC: RxBaseVC<FavoritesVM> {
    // MARK: - IBOutlets
    @IBOutlet weak var tbMovieList: MoviesRxTableView!
    
    // MARK: - Variables
    private let viewWillAppearTrigger = PublishSubject<Void>()
    
    // MARK: - Overrides
    override func viewDidLoad() {
        setUpUI()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearTrigger.onNext(())
    }
    
    override func bindViewModel() {
        let input = Input(viewWillAppearTrigger: viewWillAppearTrigger,
                          refreshTrigger: refreshTrigger,
                          movieSelectTrigger: tbMovieList.movieSelectTrigger,
                          favoriteTrigger: tbMovieList.favoriteTrigger)
        let output = viewModel.transform(input: input)
        
        output.movieSections
            .drive(tbMovieList.rx.items(dataSource: tbMovieList.rxDataSource))
            .disposed(by: disposeBag)
        
        output.movieSections
            .skip(1)
            .map { $0.contains(where: { $0.items.isEmpty }) }
            .drive(tbMovieList.rx.isEmpty(message: "No data!\nGo to Movies List to add Movies to Favorites"))
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
    }

    // MARK: - Private functions
    private func setUpUI() {
        title = "Favorites"
        initRefreshControl()
        tbMovieList.refreshControl = refreshControl
    }
}
