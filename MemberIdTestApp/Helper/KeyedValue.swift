//
//  KeyedValue.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 17/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftyJSON

open class KeyedValue: Object {
    
    @objc dynamic open var key: String = ""
    @objc dynamic open var value: String?
    
    override public static func primaryKey() -> String? {
        return "key"
    }
}
