//
//  UIViewController+Extensions.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 17/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {

    var heightScreen: CGFloat {
        return UIScreen.main.bounds.height
    }

    var widthScreen: CGFloat {
        return UIScreen.main.bounds.width
    }

    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }
    
    func setAlertMessage(title: String? = nil, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.endEditingKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func endEditingKeyboard() {
        view.endEditing(true)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func validateEmail(_ candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
}

extension UIViewController {
    
   func showIndicatorMBProgressHUD() {
      let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
      Indicator.isUserInteractionEnabled = false
      Indicator.show(animated: true)
   }
    
   func hideIndicatorMBProgressHUD() {
      MBProgressHUD.hide(for: self.view, animated: true)
   }
}
