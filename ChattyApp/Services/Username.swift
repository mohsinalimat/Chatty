//
//  UsernameEngine.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/26/21.
//

import UIKit
import Firebase

class Username: NSObject {
    
    enum DataTypes: String {
        case userID = "userID"
        case created = "created"
        case username = "_username"
    }
    
    
    var valid: Bool {
        get {
            return self.isValid()
        }
    }
    
    
    private var username: String!
    private let usernameCollection = Firestore.firestore().collection("usernames")
    private let genericError = NSError(domain: "GENERIC_ERROR", code: 0, userInfo: [NSLocalizedDescriptionKey: GENERIC_ERROR])
    private let takenError = NSError(domain: "USERNAME_TAKEN_ERROR", code: 0, userInfo: [NSLocalizedDescriptionKey: USERNAME_TAKEN_ERROR])
    private let invalidError = NSError(domain: "USERNAME_INVALID_ERROR", code: 0, userInfo: [NSLocalizedDescriptionKey: USERNAME_INVALID_ERROR])
    
    
    required init(_ username: String) {
        self.username = username.lowercased()
    }
    
    
    public func record(forUserWithID userID: String, _ completion: @escaping (_ error: NSError?) -> Void) {
        if !self.valid {
            completion(self.invalidError)
            return
        }
        
        self.isTaken { taken, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let taken = taken else {
                completion(self.genericError)
                return
            }
            
            if taken {
                completion(self.takenError)
                return
            }
            
            let usernameDocument = self.usernameCollection.document(self.username)
            usernameDocument.setData([
                
                DataTypes.userID.rawValue: userID,
                DataTypes.created.rawValue: Date().toFirebaseTimestamp(),
                DataTypes.username.rawValue: usernameDocument.documentID,
                
            ], merge: true) { error in
                completion(error?.asNSError)
            }
        }
    }
    
    
    public func isTaken(_ completion: @escaping (_ taken: Bool?, _ error: NSError?) -> Void) {
        self.getDocument { snapshot, error in
            completion(snapshot?.exists, error)
        }
    }
    
    
    // MARK: - PRIVATE METHODS
    
    
    private func getDocument(_ completion: @escaping (_ documents: DocumentSnapshot?, _ error: NSError?) -> Void) {
        self.usernameCollection.document(self.username).getDocument { snapshot, error in
            completion(snapshot, error?.asNSError)
        }
    }
    
    
    private func isValid() -> Bool {
        let validChar = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-."
        let characterset = CharacterSet(charactersIn: validChar)
        return !(self.username.isEmpty)
            && !(self.username.count < 5)
            && !(self.username.count > 20)
            && !((self.username.rangeOfCharacter(from: characterset.inverted) != nil))
    }
    
}
