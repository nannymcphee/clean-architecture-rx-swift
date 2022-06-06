//
//  MoviesRxTableView.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 20/05/2022.
//

import UIKit
import DNDomain
import RxSwift
import RxDataSources

class MoviesRxTableView: UITableView {
    // MARK: - Variables
    public let favoriteTrigger = PublishSubject<Movie>()
    public let movieSelectTrigger = PublishSubject<MovieItem>()
    
    public lazy var rxDataSource = RxTableViewSectionedReloadDataSource<MovieSection>(
        configureCell: { [weak self] (_, tableView, indexPath, item) -> UITableViewCell in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.reuseIdentifier,
                                                           for: indexPath) as? MovieListTableViewCell else {
                return UITableViewCell()
            }
            
            cell.populateData(item)
            cell.delegate = self
            return cell
        })
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Overrides
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupView()
        setUpBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setUpBinding()
    }
    
    // MARK: - Private functions
    private func setupView() {
        register(MovieListTableViewCell.reuseIdentifier)
        clipsToBounds = true
        separatorStyle = .none
        if #available(iOS 15, *) {
            sectionHeaderTopPadding = 0
        }
        setUpSectionHeaderTitle()
    }
    
    private func setUpSectionHeaderTitle() {
        rxDataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].sectionTitle
        }
    }
    
    private func setUpBinding() {
        rx.modelSelected(MovieItem.self)
            .bind(to: movieSelectTrigger)
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions
extension MoviesRxTableView: MovieListCellDelegate {
    func didTapButtonFavorite(movie: Movie) {
        favoriteTrigger.onNext(movie)
    }
}
