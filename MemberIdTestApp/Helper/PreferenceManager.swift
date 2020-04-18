//
//  PreferenceManager.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 17/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation

class PreferenceManager: NSObject {
    
    private static let Token = "token"
    private static let FinishedOnboarding = "finished_onboarding"
    
    static let instance = PreferenceManager()
    
    private let userDefaults: UserDefaults
    
    override init() {
        userDefaults = UserDefaults.standard
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    var token: String? {
        get {
            return userDefaults.string(forKey: PreferenceManager.Token)
        }
        set(newToken) {
            if let token = newToken {
                userDefaults.set(token, forKey: PreferenceManager.Token)
            } else {
                userDefaults.removeObject(forKey: PreferenceManager.Token)
            }
        }
    }
    
    var finishedOnboarding: Bool {
        get {
            return userDefaults.bool(forKey: PreferenceManager.FinishedOnboarding)
        }
        set {
            userDefaults.set(true, forKey: PreferenceManager.FinishedOnboarding)
        }
    }
    
}
