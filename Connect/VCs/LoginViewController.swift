//
//  LoginViewController.swift
//  Connect
//
//  Created by Jayden Dagsa on 11/4/20.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .systemBlue
        emailTextField.textColor = .label
        emailTextField.attributedPlaceholder = NSAttributedString (string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .systemBlue
        passwordTextField.textColor = .label
        passwordTextField.attributedPlaceholder = NSAttributedString (string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        
        handleTextField()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "signInToTabBarVC", sender: nil)
        }
    }
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            loginButton.setTitleColor(.systemGray2, for: .normal)
            loginButton.isEnabled = false
            return
        }
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.isEnabled = true
    }
    
    
    @IBAction func loginButton_TouchUpInside(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { authResult, error in
            if error != nil {
                return
            }
            
            self.performSegue(withIdentifier: "signInToTabBarVC", sender: nil)
        })
        
    }
}
