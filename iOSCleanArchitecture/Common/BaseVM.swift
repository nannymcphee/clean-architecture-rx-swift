//
//  BaseVM.swift
//  NetflixClone
//
//  Created by Duy Nguyen on 31/03/2022.
//

import RxSwift
import RxCocoa

open class BaseVM: NSObject {
    public let disposeBag = DisposeBag()
    
    override public init() {
        super.init()
        
        print("---------> 🍏 🍏 🍏 inited \(type(of: self))")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        print("---------> 🍎 🍎 🍎 deinited \(type(of: self))")
    }
}
