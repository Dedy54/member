//
//  Core.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 17/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import RealmSwift

public class Core: NSObject {
    
    public static func setup(home: String, customSessionManager: AppSessionManager? = nil) {
        var buildVersion = 0
        if let infoDict = Bundle.main.infoDictionary {
            buildVersion = Int(infoDict["CFBundleVersion"] as! String)!
        }
        
        let config = Realm.Configuration(
            schemaVersion: UInt64(buildVersion),
            migrationBlock: { (migration, oldSchemaVersion) in
                if (oldSchemaVersion < buildVersion) {
                    print("<<REALM: PROVIDED SCHEMA VERSION IS LESS THAN LAST SET VERSION>>")
                }
        }, deleteRealmIfMigrationNeeded: true, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
        if let url = config.fileURL {
            print(url.absoluteString)
        }
        CoreService.instance.home = home
        if let customSessionManager = customSessionManager {
            CoreService.instance.manager = customSessionManager
        }
    }
    
    public static func deleteAllObjects(){
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    }
}
