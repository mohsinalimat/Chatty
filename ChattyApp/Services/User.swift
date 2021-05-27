//
//  UserEngine.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/25/21.
//

import UIKit
import Firebase

class User: NSObject {
    
    
    enum DataTypes: String {
        case userID = "userID"
        case created = "created"
        case phoneNumber = "phoneNumber"
    }
    
    
    var userID: String!
    var reference: DocumentReference!
    
    
    private let userCollection = Firestore.firestore().collection("users")
    
    
    required init(withID userID: String) {
        self.userID = userID
        self.reference = self.userCollection.document(userID)
    }
    
    
    public func doesUserExists(_ completion: @escaping (_ exists: Bool?, _ error: NSError?) -> Void) {
        self.reference.getDocument { snapshot, error in
            completion(snapshot?.exists, error?.asNSError)
        }
    }
    
    
    public func setData(_ data: [User.DataTypes: Any], _ completion: @escaping (_ error: NSError?) -> Void) {
        self.userCollection.document(self.userID).setData(data.rawValues, merge: true) { error in
            completion(error?.asNSError)
        }
    }
    
    static public func doesUserExist(whereField field: User.DataTypes, isEqualTo value: Any, _ completion: @escaping (_ exists: Bool?, _ error: NSError?) -> Void) {
        Firestore.firestore().collection("users").whereField(field.rawValue, isEqualTo: value).getDocuments { snapshot, error in
            guard let empty = snapshot?.documents.isEmpty else {
                completion(nil, error?.asNSError)
                return
            }
            completion(!empty, error?.asNSError)
        }
        
        
    }

}