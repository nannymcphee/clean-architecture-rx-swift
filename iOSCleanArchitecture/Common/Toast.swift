//
//  Toast.swift
//  NetflixClone
//
//  Created by Duy Nguyen on 31/03/2022.
//

import UIKit
import SnapKit

class Toast {
    static func show(message: String, on view: UIView, with align: Alignment = .bottom) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 6
        toastContainer.clipsToBounds = true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping

        toastContainer.addSubview(toastLabel)
        view.addSubview(toastContainer)
        toastLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(35)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        if align == .center {
            toastContainer.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        } else {
            toastContainer.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(75)
                $0.centerX.equalToSuperview()
            }
        }

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: { _ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    static func showCenter(message: String,
                           completion: CallBackClosure? = nil,
                           cornerRadius: CGFloat = 6,
                           duration: TimeInterval = 1.5,
                           backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.7),
                           dimBackgroundColor: UIColor = .clear) {
        guard let keyWindow = UIWindow.key else { return }
        
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = backgroundColor
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = cornerRadius
        toastContainer.clipsToBounds = true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping

        toastContainer.addSubview(toastLabel)
        keyWindow.addSubview(toastContainer)
        
        toastLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(35)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        toastContainer.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().inset(20)
            make.right.lessThanOrEqualToSuperview().inset(20)
        }

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: duration, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                completion?()
            })
        })
    }
    
    enum ToastType {
        case success
        case failure
    }
    
    enum Alignment {
        case center, bottom
    }
    
    static func centerImageType(message: String,
                                type: ToastType,
                                completion: CallBackClosure? = nil) {
        guard let keyWindow = UIWindow.key else { return }
        
        let toastContainer = UIView()
        toastContainer.backgroundColor = UIColor.black
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 6
        toastContainer.clipsToBounds = true
        
        let image: UIImage?
        switch type {
        case .failure:
            image = UIImage(named: "ic_error")
        case .success:
            image = UIImage(named: "ic_toast_success")
        }
        
        keyWindow.addSubview(toastContainer)
        toastContainer.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.width.lessThanOrEqualTo(keyWindow.frame.size.width - 130)
        }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        toastContainer.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }

        let toastLabel = UILabel()
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping

        toastContainer.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }

        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 1, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
                completion?()
            })
        })
    }
}
