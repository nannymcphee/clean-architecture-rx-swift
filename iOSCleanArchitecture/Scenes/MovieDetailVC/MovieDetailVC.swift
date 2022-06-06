//
//  MovieDetailVC.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailVC: RxBaseVC<MovieDetailVM> {
    // MARK: - IBOutlets
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var vNavContainer: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var lbReleasedDate: UILabel!
    @IBOutlet weak var lbGerne: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func bindViewModel() {
        let input = Input(backTrigger: btnBack.rx.controlEvent(.touchUpInside).asObservable(),
                          favoriteTrigger: btnFavorite.rx.controlEvent(.touchUpInside).asObservable())
        let output = viewModel.transform(input: input)
        
        output.thumbnailURL
            .drive(with: self, onNext: { vc, url in
                vc.ivThumbnail.setImage(url: url, placeholder: R.image.ic_placeholder())
            })
            .disposed(by: disposeBag)
        
        output.movieName
            .drive(lbName.rx.text)
            .disposed(by: disposeBag)
        
        output.movieReleasedDate
            .drive(lbReleasedDate.rx.text)
            .disposed(by: disposeBag)
        
        output.movieGerne
            .drive(lbGerne.rx.text)
            .disposed(by: disposeBag)
        
        output.moviePrice
            .drive(lbPrice.rx.text)
            .disposed(by: disposeBag)
        
        output.movieDescription
            .drive(tvDescription.rx.text)
            .disposed(by: disposeBag)
        
        output.isFavorited
            .drive(btnFavorite.rx.isSelected)
            .disposed(by: disposeBag)
    }

    // MARK: - Private functions
    private func setUpUI() {
        isSwipeBackEnabled = true
        tvDescription.textContainerInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        btnFavorite.setImage(UIImage(systemName: "heart"), for: .normal)
        btnFavorite.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }
}
