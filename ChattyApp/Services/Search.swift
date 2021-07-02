//
//  Search.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 6/28/21.
//

import Foundation
import AlgoliaSearchClient
import SwiftUI


class Search {
    
    struct User: Encodable {
        var bio: String?
        var userID: String?
        var firstName: String?
        var lastName: String?
        var username: String?
        var phoneNumber: String?
        var profilePicture: String?
    }
    
    private static let client = SearchClient(appID: Algolia.appID, apiKey: Algolia.apiKey)
    
    
    public static func add(user: User,
                           _ completion: @escaping (_ response: WaitableWrapper<ObjectRevision>?, _ error: NSError?) -> Void) {
        
        guard let userID = user.userID else {
            completion(nil, NSError(domain: "INVALID_USER_OPERATION", code: 0, userInfo: [NSLocalizedDescriptionKey: INVALID_USER_OPERATION]))
            return
        }
        
        self.add(object: user, withID: userID, toIndexWithName: "users") { response, error in
            completion(response, error)
        }
        
    }
    
    
    public static func remove(userWithID userID: String,
                              _ completion: @escaping (_ response: WaitableWrapper<ObjectDeletion>?, _ error: NSError?) -> Void) {
        
        let objectID = ObjectID(rawValue: userID)
        let indexName = IndexName(rawValue: "users")
        let index = self.client.index(withName: indexName)
        
        index.deleteObject(withID: objectID, requestOptions: .none) { result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error.asNSError)
            }
        }
        
    }
    
    
    public static func add<T: Encodable>(object: T, withID id: String, toIndexWithName name: String,
                                         _ completion: @escaping (_ response: WaitableWrapper<ObjectRevision>?, _ error: NSError?) -> Void) {
        
        let objectID = ObjectID(rawValue: id)
        let indexName = IndexName(rawValue: name)
        let index = self.client.index(withName: indexName)
        
        index.replaceObject(withID: objectID, by: object) { result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error.asNSError)
            }
        }
        
    }
    
    
    public static func query(_ text: String, withHitsPerPage hits: Int,
                             _ completion: @escaping (_ response: SearchResponse?, _ error: NSError?) -> Void) {
        
        let indexName = IndexName(rawValue: "users")
        let index = self.client.index(withName: indexName)
        
        var query = Query(text)
        query.hitsPerPage = hits
        
        index.search(query: query) { result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error.asNSError)
            }
        }
        
    }
    
}
