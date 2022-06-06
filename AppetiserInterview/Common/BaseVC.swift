//
//  BaseVC.swift
//  NetflixClone
//
//  Created by Duy Nguyen on 31/03/2022.
//

import UIKit

class BaseVC: UIViewController, ErrorHandler {
    //MARK: - VARIABLES
    private let BTN_BACK_WIDTH: CGFloat = 36
    
    public var isSwipeBackEnabled: Bool = false {
        didSet {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = isSwipeBackEnabled
        }
    }

    //MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        self.initDefaultNavigationBar()
    }
    
    deinit {
        self.removeObservers()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func addObservers() {
        
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initDefaultNavigationBar() {
//        navigationController?.isNavigationBarHidden = true
//        let navigationBar = navigationController?.navigationBar
//        navigationBar?.backgroundColor = .white
//        navigationBar?.isTranslucent = false
    }
    
    // MARK: - PUBLIC FUNCTIONS
    public func showHubLoadingIndicator(in parentView: UIView? = nil,
                                        loadingMessage: String = "",
                                        allowsUserInteraction: Bool = true) {
        DispatchQueue.main.async {
            DNLoadingViewHelper.showLoading(in: parentView ?? UIWindow.key ?? self.view,
                                            loadingMessage: loadingMessage,
                                            allowsUserInteraction: allowsUserInteraction)
        }
    }
    
    public func dismissHubIndicator() {
        DispatchQueue.main.async {
            DNLoadingViewHelper.hideLoading()
        }
    }
    
    public func showBackButton() {
        let btnBack = UIButton(type: .custom)
        btnBack.frame = CGRect(x: 0, y: 0, width: BTN_BACK_WIDTH, height: BTN_BACK_WIDTH)
        btnBack.setImage(#imageLiteral(resourceName: "icBack"), for: .normal)
        btnBack.tintColor = AppColors.black
        btnBack.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let leftBar = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = leftBar
    }
    
    public func showScreenTitle(_ title: String) {
        let lbTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        lbTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbTitle.textAlignment = .center
        lbTitle.text = title
        self.navigationItem.titleView = lbTitle
    }
    
    public func getIconBarButtonItem(icon: UIImage?, target: UIViewController, action: Selector?) -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: icon, style: .plain, target: target, action: action)
        barButton.tintColor = AppColors.black
        return barButton
    }
    
    public func onNetworkConnectionRestored() {}
    
    //MARK: - ACTIONS
    @objc func backButtonPressed(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if let navigation = self.navigationController {
            if navigation.viewControllers.count == 1 {
                self.dismiss(animated: true, completion: nil)
            } else {
                navigation.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func reloadData() {}
}

