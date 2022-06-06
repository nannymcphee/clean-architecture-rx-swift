//
//  RxBaseVC.swift
//  NetflixClone
//
//  Created by Duy Nguyen on 31/03/2022.
//

import UIKit
import RxSwift

class RxBaseVC<T: ViewModelTransformable>: BaseVC {
    typealias Input = T.Input
    
    public let viewModel: T
    public var disposeBag = DisposeBag()
    public var refreshControl = UIRefreshControl()
    public let refreshTrigger = PublishSubject<Void>()
    
    var keyboardHeight: Observable<CGFloat> {
        let keyboardVisibleHeight = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                return (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
        let keyboardHiddenHeight = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in
                return 0.0
            }
        return Observable.merge(keyboardVisibleHeight, keyboardHiddenHeight)
    }
    
    init(viewModel: T, nibName: String? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("🚀 \(T.self) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    open func bindViewModel() {}
    
    public func initRefreshControl() {
        refreshControl.rx
            .controlEvent(.valueChanged)
            .asObservable()
            .bind(to: refreshTrigger)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: BaseVC {
    var isLoading: Binder<Bool> { Binder(base) { $1 ? $0.showHubLoadingIndicator() : $0.dismissHubIndicator() }}
    var error: Binder<(Error, ErrorAction)> {
        Binder(base) { (base: Base, payload: (err: Error, action: ErrorAction)) in
            base.handle(error: payload.err, action: payload.action)
        }
    }
}
