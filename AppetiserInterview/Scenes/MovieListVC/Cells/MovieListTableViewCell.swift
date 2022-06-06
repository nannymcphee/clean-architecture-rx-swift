//
//  MovieListTableViewCell.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit
import RxSwift
import DNDomain

protocol MovieListCellDelegate: AnyObject {
    func didTapButtonFavorite(movie: Movie)
}

class MovieListTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var lbMovieName: UILabel!
    @IBOutlet weak var lbGenre: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    
    // MARK: - Variables
    private var movie: Movie?
    private var disposeBag = DisposeBag()
    public weak var delegate: MovieListCellDelegate?
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        btnFavorite.isSelected = false
        ivThumbnail.image = nil
        ivThumbnail.cancelDownloadTask()
        [lbMovieName, lbPrice, lbGenre].forEach { $0.text = "" }
        disposeBag = DisposeBag()
    }
    
    // MARK: - Public functions
    public func populateData(_ item: MovieItem) {
        let movie = item.movie
        self.movie = movie
        ivThumbnail.setImage(url: movie.artworkUrl1024, placeholder: R.image.ic_placeholder())
        lbMovieName.text = movie.trackName
        lbGenre.text = movie.primaryGenreName
        lbPrice.text = "\(movie.trackPrice) \(movie.currency)"
        btnFavorite.isSelected = movie.isFavorited
    }
    
    // MARK: - Private functions
    private func setUpUI() {
        ivThumbnail.customBorder(cornerRadius: 8, borderWidth: 1.0, color: .clear)
        btnFavorite.setImage(UIImage(systemName: "heart"), for: .normal)
        btnFavorite.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }
    
    // MARK: - IBActions
    @IBAction func btnFavoritePressed(_ sender: Any) {
        if let movie = movie {
            delegate?.didTapButtonFavorite(movie: movie)
        }
    }
}
