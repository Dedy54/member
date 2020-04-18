//
//  UIString+Extension.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 18/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation

extension String {
    
    var isEmptyAfterTrim: Bool {
        get {
            return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
        }
    }
    
    // Generating Random String
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
