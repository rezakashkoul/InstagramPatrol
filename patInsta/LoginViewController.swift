//
//  LoginViewController.swift
//  patInsta
//
//  Created by Reza Kashkoul on 23-Esfand-1400 .
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func setCookie(userCookie: String)
}

class LoginViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    @IBAction func loginButtonAction(_ sender: Any) {
        delegate?.setCookie(cookie: textView.text)
        dismiss(animated: true)
    } 
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Set cookie and login"
    }


}

