//
//  ErrorHandler.swift
//  NetflixClone
//
//  Created by Duy Nguyen on 31/03/2022.
//

typealias CallBackClosure = () -> Void

enum ErrorAction: Equatable {
    case toast
    case toastWithIcon
    case log
    
    static func == (lhs: ErrorAction, rhs: ErrorAction) -> Bool {
        switch lhs {
        case .log:
            switch rhs {
            case .log:
                return true
            default:
                return false
            }
        case .toastWithIcon:
            switch rhs {
            case .toastWithIcon:
                return true
            default:
                return false
            }
        case .toast:
            switch rhs {
            case .toast:
                return true
            default:
                return false
            }
        }
    }
}

protocol ErrorHandler {
    func handle<T>(error: T?, action: ErrorAction?, completion: CallBackClosure?)
    func handle(errorMessage: String, action: ErrorAction?, completion: CallBackClosure?)
}

extension ErrorHandler {
    func handle<T>(error: T?, action: ErrorAction? = .log, completion: CallBackClosure? = nil) {
        var mutableAction = action
        
        #if DEBUG
        if mutableAction == .log {
            mutableAction = .toast
        }
        #endif
        
        if let err = error as? Error {
            handle(errorMessage: err.localizedDescription, action: mutableAction, completion: completion)
        } else if let errMsg = error as? String {
            handle(errorMessage: errMsg, action: mutableAction, completion: completion)
        } else if let unwrap = error {
            handle(errorMessage: String(describing: unwrap), action: mutableAction, completion: completion)
        } else {
            handle(errorMessage: "Unknow error !!!", action: mutableAction, completion: completion)
        }
    }
    
    func handle(errorMessage: String, action: ErrorAction? = .log, completion: CallBackClosure? = nil) {
        switch action {
        case .log:
            debugPrint(errorMessage)
            completion?()
        case .toast:
            Toast.showCenter(message: errorMessage, completion: completion)
        case .toastWithIcon:
            Toast.centerImageType(message: errorMessage, type: .failure, completion: completion)
        case .none:
            completion?()
        }
    }
}
