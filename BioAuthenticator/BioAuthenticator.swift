//
//  BioAuthenticator.swift
//  BioAuth
//
//  Created by Meniny on 03/11/17.
//  Copyright © 2017 Meniny.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import LocalAuthentication

// success block
public typealias AuthenticationSuccess = (() -> ())

// failure block
public typealias AuthenticationFailure = ((BioErrors) -> ())

open class BioAuthenticator: NSObject {

    struct Static {
        static let instance = BioAuthenticator()
    }
    
    // this is the Swift way to do singletons
    class var shared: BioAuthenticator {
       return Static.instance
    }
}

// MARK:- Public

public extension BioAuthenticator {
    
    // checks if Biometric Authentication is available on the device.
    func isBiometricAuthenticationAvailable() -> Bool {
        var error: NSError? = nil
        
        if LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return (error == nil)
        }
        return false
    }
    
    // checks if Face ID is avaiable on device
    public func isFaceIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            return (LAContext().biometryType == .typeFaceID)
        }
        return false
    }
    
    // Biometric authentication
    func authenticateUserWithBioMetrics(reason: String = "", fallbackTitle: String? = "", cancelTitle: String? = "", success successBlock:@escaping AuthenticationSuccess, failure failureBlock:@escaping AuthenticationFailure) {
        
        let reasonString = reason.isEmpty ? BioAuthenticator.shared.defaultBiometricAuthenticationReason() : reason
        
        let context = LAContext()
        context.localizedFallbackTitle = fallbackTitle
        if #available(iOS 10.0, *) {
            context.localizedCancelTitle = cancelTitle
        } else {
            // Fallback on earlier versions
        }
        
        // evaluate policy
        BioAuthenticator.shared.evaluate(policy: LAPolicy.deviceOwnerAuthenticationWithBiometrics, with: context, reason: reasonString, success: successBlock, failure: failureBlock)
    }
    
    // Passcode authentication
    func authenticateUserWithPasscode(reason: String = "", cancelTitle: String? = "", success successBlock:@escaping AuthenticationSuccess, failure failureBlock:@escaping AuthenticationFailure) {
        
        let reasonString = reason.isEmpty ? BioAuthenticator.shared.defaultPasscodeAuthenticationReason() : reason
        
        let context = LAContext()
        if #available(iOS 10.0, *) {
            context.localizedCancelTitle = cancelTitle
        } else {
            // Fallback on earlier versions
        }
        
        // evaluate policy
        BioAuthenticator.shared.evaluate(policy: LAPolicy.deviceOwnerAuthentication, with: context, reason: reasonString, success: successBlock, failure: failureBlock)
    }
}

// MARK:- evaluate policy
extension BioAuthenticator {
   
    func evaluate(policy: LAPolicy, with context: LAContext, reason: String, success successBlock:@escaping AuthenticationSuccess, failure failureBlock:@escaping AuthenticationFailure) {
        
        context.evaluatePolicy(policy, localizedReason: reason) { (success, err) in
            if success { successBlock() }
            else {
                let errorType = BioErrors(error: err as! LAError)
                failureBlock(errorType)
            }
        }
    }
}

// MARK:- Get default messages
extension BioAuthenticator {
    // get default bio authentication reason
    func defaultBiometricAuthenticationReason() -> String {
        return BioReasonMessage.default.rawValue
    }
    
    // get reason after too many failed attempts.
    func defaultPasscodeAuthenticationReason() -> String {
        return BioReasonMessage.lockout.rawValue
    }
}
