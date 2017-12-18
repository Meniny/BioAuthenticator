//
//  BioControllers.swift
//  Sample
//
//  Created by 李二狗 on 2017/12/18.
//  Copyright © 2017年 李二狗. All rights reserved.
//

import Foundation
import UIKit
import BioAuth

public extension UIViewController {
    
    public typealias AlertDismissClosure = (() -> ())
    
    public func show(_ style: UIAlertControllerStyle,
                     title alertTitle: String?,
                     message: String?,
                     button: String? = nil,
                     dismiss:UIViewController.AlertDismissClosure? = nil) {
        
        let controller = UIAlertController.init(title: alertTitle, message: message, preferredStyle: style)
        controller.addAction(UIAlertAction.init(title: button ?? "Okay", style: .cancel) { (action) in
            dismiss?()
        })
        self.present(controller, animated: true, completion: nil)
    }
}

public class BiometricController: UIViewController {
    
    public enum BiometricType {
        case faceID, touchID
        
        var text: String {
            return self == .faceID ? "FaceID" : "TouchID"
        }
    }
    
    public var biometricAuthType: BiometricController.BiometricType = .touchID
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        guard BioAuthenticator.shared.isBiometricAuthenticationAvailable else {
            self.show(.alert, title: "The Biometric Authentication is not available", message: nil)
            return
        }
        
        let authingFaceID = biometricAuthType == .faceID
        let available = authingFaceID ? BioAuthenticator.shared.isFaceIDAvailable : BioAuthenticator.shared.isTouchIDAvailable
        
        guard available else {
            self.show(.alert, title: "The \(biometricAuthType.text) Authentication is not available", message: nil)
            return
        }
        
        BioAuthenticator.shared.authenticateUserWithBioMetrics(reason: "Just do IT", fallbackTitle: "Fallback title", cancelTitle: "Cancel title", success: { [weak self] in
            self?.show(.alert, title: "Success", message: nil)
        }) { [weak self] (error) in
            self?.show(.alert, title: error.message, message: nil)
        }
    }
}

public class PasscodeController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        BioAuthenticator.shared.authenticateUserWithPasscode(reason: "Just do IT", cancelTitle: "cancel title", success: { [weak self] in
            self?.show(.alert, title: "success", message: nil)
        }) { [weak self] (error) in
            self?.show(.alert, title: error.message, message: nil)
        }
    }
}
