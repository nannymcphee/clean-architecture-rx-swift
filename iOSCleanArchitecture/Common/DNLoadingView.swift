//
//  DNLoadingView.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit

class DNLoadingViewHelper {
    private static var vLoadingIndicator = DNLoadingView()
    static var isLoading: Bool {
        return vLoadingIndicator.isLoading
    }
    
    static func showLoading(in parentView: UIView,
                            loadingMessage: String? = nil,
                            allowsUserInteraction: Bool = false) {
        guard !isLoading else { return }
        vLoadingIndicator.show(in: parentView, loadingMessage: loadingMessage, allowsUserInteraction: allowsUserInteraction)
    }
    
    static func hideLoading() {
        vLoadingIndicator.hideLoading()
    }
    
    static func setConfig(_ config: DNLoadingView.Config) {
        vLoadingIndicator.setConfig(config)
    }
}

class DNLoadingView: UIView {
    // MARK: - UI Elements
    private lazy var indicatorContainer: UIStackView = {
        let indicatorContainer = UIStackView()
        indicatorContainer.axis = .vertical
        indicatorContainer.spacing = 8
        return indicatorContainer
    }()
    
    private lazy var lbMessage: UILabel = {
        let lbMessage = UILabel()
        lbMessage.textAlignment = .center
        lbMessage.font = currentConfig.messageFont
        lbMessage.textColor = currentConfig.indicatorColor
        return lbMessage
    }()
    
//    private lazy var loadingIndicator: NVActivityIndicatorView = {
//        return NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: currentConfig.indicatorSize, height: currentConfig.indicatorSize),
//                                       type: .ballSpinFadeLoader,
//                                       color: currentConfig.indicatorColor)
//    }()
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0,
                                                         width: currentConfig.indicatorSize, height: currentConfig.indicatorSize))
        view.style = .large
        view.color = .gray
        return view
    }()
    
    // MARK: - Configuration
    struct Config {
        let indicatorSize: CGFloat
        let indicatorColor: UIColor
        let messageFont: UIFont
        
        static let `default` = Config(indicatorSize: 38,
                                      indicatorColor: .gray,
                                      messageFont: UIFont.systemFont(ofSize: 12, weight: .regular))
    }
    
    // MARK: - Variables
    private var currentConfig: Config = .default
    
    public var isLoading: Bool {
        return loadingIndicator.isAnimating
    }

    // MARK: - Overrides
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    public func show(in parentView: UIView,
                     loadingMessage: String?,
                     allowsUserInteraction: Bool = false) {
        lbMessage.isHidden = loadingMessage.orEmpty.isEmpty
        lbMessage.text = loadingMessage
        loadingIndicator.startAnimating()
        
        parentView.addSubview(self)
        parentView.isUserInteractionEnabled = allowsUserInteraction
        
        self.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public func hideLoading() {
        loadingIndicator.stopAnimating()
        superview?.isUserInteractionEnabled = true
        self.removeFromSuperview()
    }
    
    public func setConfig(_ config: Config) {
        currentConfig = config
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: config.indicatorSize, height: config.indicatorSize)
        loadingIndicator.color = config.indicatorColor
        lbMessage.textColor = config.indicatorColor
        lbMessage.font = config.messageFont
    }
    
    // MARK: - Private functions
    private func setUpView() {
        addSubview(indicatorContainer)
        indicatorContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        indicatorContainer.addArrangedSubview(loadingIndicator)
        indicatorContainer.addArrangedSubview(lbMessage)
    }
}
