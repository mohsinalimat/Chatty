//
//  UserStore.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/30/21.
//

import RealmSwift

class UserStore: Object {
    
    @objc dynamic var userID: String?
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var username: String?
    @objc dynamic var phoneNumber: String?
    @objc dynamic var profilePicture: String?
    
    @objc dynamic var created: Date?
    @objc dynamic var dateOfBirth: Date?
    
    override static func primaryKey() -> String? {
        return "userID"
    }
    
    public func store(_ completion: @escaping (_ error: NSError) -> Void) {
        do {
            
            let realm = try Realm()
            try realm.write {
                realm.add(self, update: .modified)
            }
            
            Logging.log(realm.configuration.fileURL ?? "", as: .info)
            
        } catch {
            
            completion(error.asNSError)
            
        }
    }
    
}
