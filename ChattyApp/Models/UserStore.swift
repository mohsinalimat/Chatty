//
//  UserStore.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/30/21.
//

import RealmSwift

class UserStore: Object, Encodable {
    
    @objc dynamic var bio: String?
    @objc dynamic var userID: String?
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var username: String?
    @objc dynamic var phoneNumber: String?
    @objc dynamic var profileCover: String?
    @objc dynamic var profilePicture: String?
    
    @objc dynamic var created: Date?
    @objc dynamic var dateOfBirth: Date?
    
    @objc dynamic var isPrivate: Bool = true
    
    
    override static func primaryKey() -> String? {
        return "userID"
    }
    
    public func store(_ completion: @escaping (_ error: NSError?) -> Void) {
        do {
            
            let realm = try Realm()
            try realm.write {
                realm.add(self, update: .modified)
            }
            
            Logging.log(realm.configuration.fileURL ?? "", as: .info)
            completion(nil)
            
        } catch {
            
            completion(error.asNSError)
            
        }
    }
    
    
    public static func objects(where predicate: (_ user: UserStore) -> Bool,
                               _ completion: @escaping (_ objects: [UserStore]?, _ error: NSError?) -> Void) {
        do {
            
            let realm = try Realm()
            let objects = realm.objects(UserStore.self).filter(predicate)
            completion(objects, nil)
            
        } catch {
            
            completion(nil, error.asNSError)
            
        }
    }
    
    
    public static func firstObject(where predicate: (_ user: UserStore) -> Bool,
                                   _ completion: @escaping (_ realmUser: UserStore?, _ error: NSError?) -> Void) {
        self.objects(where: predicate) { objects, error in
            completion(objects?.first, error)
        }
    }
    
}
