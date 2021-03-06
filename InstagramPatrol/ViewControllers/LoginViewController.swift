//
//  LoginViewController.swift
//  InstagramPatrol
//
//  Created by Reza Kashkoul on 23-Esfand-1400 .
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func setCookie(userCookie: String)
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var loginButton: UIButton!

    @IBAction func loginButtonAction(_ sender: Any) {
//        delegate?.setCookie(userCookie: textView.text)
        dismiss(animated: true)
    }
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 20
    }
    
    
}

