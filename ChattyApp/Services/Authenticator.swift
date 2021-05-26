//
//  Authenticator.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/21/21.
//

import UIKit
import Firebase

class Authenticator: NSObject {
    
    public func verify(phoneNumber: String, _ completion: @escaping (_ verificationID: String?, _ error: NSError?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            completion(verificationID, error?.asNSError)
        }
    }
    
    public func signIn(withVerificationID verificationID: String, verificationCode: String, _ completion: @escaping (_ authResult: AuthDataResult?, _ error: NSError?) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { authResult, error in
            completion(authResult, error?.asNSError)
        }
    }
    
}
