//
//  AwardsType.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 17/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

enum AwardsType : CaseIterable {
    case voucher
    case products
    case giftcard
    case undeclare
    
    static func random<G: RandomNumberGenerator>(using generator: inout G) -> AwardsType {
        return AwardsType.allCases.randomElement(using: &generator)!
    }

    static func random() -> AwardsType {
        var g = SystemRandomNumberGenerator()
        return AwardsType.random(using: &g)
    }
}

class Award: Object {
    
    @objc dynamic var identifier: String?
    @objc dynamic var title: String?
    @objc dynamic var images: String?
    
    var awardsType: AwardsType = .voucher
    
    override public static func primaryKey() -> String? {
        return "identifier"
    }
    
    public static func with(realm: Realm, json: JSON) -> Award? {
        let identifier = json["id"].stringValue
        if identifier == "" {
            return nil
        }
        var obj = realm.object(ofType: Award.self, forPrimaryKey: identifier)
        if obj == nil {
            obj = Award()
            obj?.identifier = identifier
        } else {
            obj = Award(value: obj!)
        }
        if json["title"].exists() {
            obj?.title = json["title"].stringValue
        }
        if json["images"].exists() {
            obj?.images = json["images"].stringValue
        }
        
        return obj
    }
    
    public static func with(json: JSON) -> Award? {
        return with(realm: try! Realm(), json: json)
    }
}
