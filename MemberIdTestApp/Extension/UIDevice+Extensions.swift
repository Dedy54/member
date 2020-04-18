//
//  UIDevice+Extensions.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 17/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import UIKit

enum Device {
    case iPhoneClassic
    case iPhone4orS
    case iPhone5orS
    case iPhone6or7orS
    case iPhone6or7PlusOrS
    case iPhoneX
    case unknown
}

extension UIDevice {
    
    func isPad() -> Bool {
        return UIDevice().userInterfaceIdiom == .pad
    }
    
    func isPhone() -> Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    func currentDeviceIPhone() -> Device {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
                return .iPhoneClassic
            case 960:
                print("iPhone 4 or 4S")
                return .iPhone4orS
            case 1136:
                print("iPhone 5 or 5S or 5C")
                return .iPhone5orS
            case 1334:
                print("iPhone 6 or 6S")
                return .iPhone6or7orS
            case 2208:
                print("iPhone 6+ or 6S+")
                return .iPhone6or7PlusOrS
            case 2436:
                print("iPhone X")
                return .iPhoneX
            default:
                print("unknown")
                return .unknown
            }
        }
        return .unknown
    }
    
}

struct DeviceInfo {
    struct Orientation {
        // indicate current device is in the LandScape orientation
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}
