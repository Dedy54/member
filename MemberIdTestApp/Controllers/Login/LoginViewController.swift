//
//  LoginViewController.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 18/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginViewControllerDelegate {
    func loginViewController(needRefresh controller: LoginViewController)
}

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!{
        didSet{
            emailField.layer.cornerRadius = 8
            emailField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    @IBOutlet weak var signInButton: UIButton!{
        didSet{
            signInButton.layer.cornerRadius = 8
            signInButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    
    private let disposeBag = DisposeBag()
    var loginViewControllerDelegate : LoginViewControllerDelegate?
    
    static func instantiateViewController() -> LoginViewController {
        let controller = R.storyboard.login.loginViewController()!
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signInButton.rx.tap
        .debounce(0.5, scheduler: MainScheduler.instance)
        .subscribe({
            [weak self] _ in
            self?.actionSignInButton()
        })
        .disposed(by: disposeBag)
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func actionSignInButton() {
        if (emailField.text?.isEmptyAfterTrim ?? true){
            self.setAlertMessage(message: "Please enter your email address")
            return
        }
        
        if self.validateEmail(emailField.text ?? "") == false {
            self.setAlertMessage(message: "Invalid email")
            return
        }
        
        self.showIndicatorMBProgressHUD()
        self.delay(1) {
            PreferenceManager.instance.finishedOnboarding = true
            self.hideIndicatorMBProgressHUD()
            self.dismiss(animated: true, completion: nil)
            self.loginViewControllerDelegate?.loginViewController(needRefresh: self)
        }
    }
}

extension LoginViewController {
    
    @objc func keyboardWillShow(_ notification: Foundation.Notification) {
        let info = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            let contentInsets = UIEdgeInsets(top: 64.0, left: 0.0, bottom: ( keyboardFrame.size.height), right: 0.0);
            self.scrollView.contentInset = contentInsets
        })
    }
    
    @objc func keyboardWillHide() {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0);
        self.scrollView.contentInset = contentInsets
    }
}
