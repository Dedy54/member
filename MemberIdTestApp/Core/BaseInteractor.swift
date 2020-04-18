//
//  BaseInteractor.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 17/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import RealmSwift

open class BaseInteractor {
    
    public var service = CoreService.instance
    
    public var perPage: Int
    public var params: [String: String]
    public var storeKey: String?
    public var lastPage = 0
    public var nextPage = 1
    public var authorization: String?
    
    private var _realm: Realm?
    
    public init(perPage: Int = 10, params: [String: String]? = nil, storeKey: String? = nil, authorization: String? = nil) {
        self.perPage = perPage
        self.params = params ?? [String: String]()
        self.authorization = authorization
    }
    
    public var realm: Realm {
        if let realm = _realm {
            return realm
        }
        return try! Realm()
    }
    
    
}
