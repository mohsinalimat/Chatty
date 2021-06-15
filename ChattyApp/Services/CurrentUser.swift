//
//  CurrentUser.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/25/21.
//

import Firebase
import RealmSwift

class CurrentUser: NSObject {
    
    private static let signOutError = "signOutError"
    private static let userCollection = Firestore.firestore().collection("users")
    
    private static let invalidOperationError = NSError(domain: "INVALID_CURRENT_USER_OPERATION", code: 0, userInfo: [NSLocalizedDescriptionKey: INVALID_CURRENT_USER_OPERATION])
    
    static var uid: String? {
        get {
            return self.user?.uid
        }
    }
    
    static var user: FirebaseAuth.User? {
        get {
            return Auth.auth().currentUser
        }
    }
    
    static var displayName: String? {
        get {
            return Auth.auth().currentUser?.displayName
        }
    }
    
    
    static public func setDisplayName(to name: String, _ completion: @escaping (_ error: NSError?) -> Void) {
        let changeRequest = CurrentUser.user?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            completion(error?.asNSError)
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
    
    
    static func isSignedIn(_ completion: @escaping (_ signedIn: Bool) -> Void) {
        CurrentUser.addStateDidChangeListener { auth, user in
            completion(user != nil)
        }
    }
    
    
    static func addStateDidChangeListener(_ completion: @escaping (_ auth: Auth, _ user: FirebaseAuth.User?) -> Void) {
        Auth.auth().addStateDidChangeListener { auth, user in
            completion(auth, user)
        }
    }
    
    
    static public func storeProfileOnDevice(_ completion: @escaping (_ error: NSError?) -> Void) {
        guard let uid = self.uid else {
            completion(self.invalidOperationError)
            return
        }
        
        self.userCollection.document(uid).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(error.asNSError)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(self.invalidOperationError)
                return
            }
            
            let user = UserStore()
            user.userID = snapshot.data()?[User.DataTypes.userID.rawValue] as? String
            user.username = snapshot.data()?[User.DataTypes.username.rawValue] as? String
            user.firstName = snapshot.data()?[User.DataTypes.firstName.rawValue] as? String
            user.lastName = snapshot.data()?[User.DataTypes.lastName.rawValue] as? String
            user.phoneNumber = snapshot.data()?[User.DataTypes.phoneNumber.rawValue] as? String
            user.profileCover = snapshot.data()?[User.DataTypes.profileCover.rawValue] as? String
            user.profilePicture = snapshot.data()?[User.DataTypes.profilePicture.rawValue] as? String
            user.created = (snapshot.data()?[User.DataTypes.created.rawValue] as? Timestamp)?.dateValue()
            user.dateOfBirth = (snapshot.data()?[User.DataTypes.dateOfBirth.rawValue] as? Timestamp)?.dateValue()
            
            user.store { error in
                completion(error)
            }
        }
    }
    
    
    static public func updateImage(for imageType: UserImageType, withImageFrom localPath: URL, _ completion: @escaping (_ error: NSError?) -> Void) {
        
        guard let userID = self.uid else {
            completion(self.invalidOperationError)
            return
        }
        
        self.storeImage(for: imageType, from: localPath) { imageName, error in
            if let error = error {
                completion(error.asNSError)
                return
            }
            
            User(withID: userID).set([
                
                (imageType == .profile) ? .profilePicture : .profileCover: imageName as Any
                
            ]) { error in completion(error) }
        }
        
    }
    
    
    // MARK: - PRIVATE
    

    static private func storeImage(for imageType: UserImageType, from url: URL, _ completion: @escaping (_ imageName: String?, _ error: NSError?) -> Void) {
        
        guard let _ = self.uid else {
            completion(nil, self.invalidOperationError)
            return
        }
        
        let isolatedPath = url.path.components(separatedBy: "/")
        let ref = Storage.storage().reference(withPath: "profileImages")
            .child(isolatedPath.last ?? "")
        
        ref.putFile(from: url, metadata: nil) { (metadata, error) in
            completion(isolatedPath.last ?? "", error?.asNSError)
            return
        }
        
    }
    
}
