//
//  CurrentUser.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/25/21.
//

import Firebase

class CurrentUser: NSObject {
    
    private static let signOutError = "signOutError"
    
    static var displayName: String? {
        get {
            return Auth.auth().currentUser?.displayName
        }
    }
    
    static public func signOut(completion: ((_ error: NSError?) -> Void)?) {
        do {
            try Auth.auth().signOut()
            completion?(nil)
            UserDefaults.standard.setValue(false, forKey: self.signOutError)
        } catch(let error) {
            completion?(error.asNSError)
            UserDefaults.standard.setValue(true, forKey: self.signOutError)
        }
    }
    
    
    static public func handleSignOutError() {
        // If there was an error signing out, try again
        if let signOutError: Bool = UserDefaults.standard.object(forKey: self.signOutError) as? Bool {
            if signOutError {
                CurrentUser.signOut(completion: nil)
            }
        }
    }
    
}
