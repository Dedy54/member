//
//  UILabel+Extension.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 18/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import UIKit
import Foundation

extension UILabel {
    
    func setAwardType(awardType: AwardsType)  {
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        self.textColor = UIColor.white
        
        switch awardType {
        case .giftcard:
            print("giftcard")
            self.backgroundColor = UIColor.red
            self.text = "Giftcard"
        case .products:
            print("products")
            self.backgroundColor = UIColor.orange
            self.text = "Products"
        case .voucher:
            print("voucher")
            self.backgroundColor = UIColor.blue
            self.text = "Voucher"
        default:
            print("")
        }
    }
    
}
