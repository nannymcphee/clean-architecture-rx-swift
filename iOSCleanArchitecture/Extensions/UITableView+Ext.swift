//
//  UITableView+Ext.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 19/05/2022.
//

import UIKit

extension UITableView {
    func showEmptyView(imageName: String = "ic_empty_data",
                       msg: String = "No data",
                       textColor: UIColor = UIColor.label,
                       bgColor: UIColor = .systemBackground,
                       blueButton: UIButton? = nil) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: bounds.size)
        let viewEmpty = UIView(frame: rect)
        viewEmpty.backgroundColor = bgColor
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        
        let msgLabel = UILabel()
        msgLabel.textColor = textColor
        msgLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        msgLabel.text = msg
        msgLabel.numberOfLines = 0
        msgLabel.textAlignment = .center
        
        let stv = UIStackView(arrangedSubviews: [imageView, msgLabel])
        stv.alignment = .center
        stv.axis = .vertical
        stv.distribution = .fill
        stv.spacing = 11
        
        imageView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(150)
        })
        
        viewEmpty.addSubview(stv)
        stv.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        if let blueBtn = blueButton {
            viewEmpty.addSubview(blueBtn)
            blueBtn.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(stv.snp.bottom).offset(20)
                make.width.equalTo(110)
                make.height.equalTo(40)
            })
        }
        
        imageView.isHidden = imageName.isEmpty
        msgLabel.isHidden = msg.isEmpty
        
        viewEmpty.layer.cornerRadius = 10
        viewEmpty.clipsToBounds = true
        backgroundView = viewEmpty
    }
    
    func showEmptyView(message: String) {
        let viewEmpty = UIView(frame: bounds)
        viewEmpty.backgroundColor = .white
        
        let msgLabel = UILabel()
        msgLabel.textColor = UIColor.systemGray
        msgLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        msgLabel.text = message
        msgLabel.numberOfLines = 0
        msgLabel.textAlignment = .center
        
        viewEmpty.addSubview(msgLabel)
        msgLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        
        backgroundView = viewEmpty
    }
    
    func removeEmptyView() {
        backgroundView = nil
    }
}
