//
//  UITableView+Bindable.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 19/05/2022.
//

import UIKit
import RxSwift

extension Reactive where Base: UITableView {
    func isEmpty(imageName: String = R.image.ic_empty_data.name,
                 message: String,
                 textColor: UIColor = UIColor.white,
                 blueButton: UIButton? = nil,
                 bgColor: UIColor = UIColor.systemBackground) -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.showEmptyView(imageName: imageName,
                                        msg: message,
                                        textColor: textColor,
                                        bgColor: bgColor,
                                        blueButton: blueButton)
            } else {
                tableView.removeEmptyView()
            }
        }
    }
}
