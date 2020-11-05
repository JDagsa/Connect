//
//  SignUpViewController.swift
//  Connect
//
//  Created by Jayden Dagsa on 11/4/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.backgroundColor = .clear
        usernameTextField.tintColor = .systemBlue
        usernameTextField.textColor = .label
        usernameTextField.attributedPlaceholder = NSAttributedString (string: usernameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        
        
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .systemBlue
        emailTextField.textColor = .label
        emailTextField.attributedPlaceholder = NSAttributedString (string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .systemBlue
        passwordTextField.textColor = .label
        passwordTextField.attributedPlaceholder = NSAttributedString (string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        profilePicture.layer.cornerRadius = 50
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfilePictureImgView))
        profilePicture.addGestureRecognizer(tapGesture)
        profilePicture.isUserInteractionEnabled = true
        handleTextField()
    }
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpButton.setTitleColor(.systemGray2, for: .normal)
            signUpButton.isEnabled = false
            return
        }
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.isEnabled = true
    }
    
    @objc func handleSelectProfilePictureImgView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss_OnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        let ref = Database.database().reference()
        print(ref.description())
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { authResult, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            let uid = Auth.auth().currentUser?.uid
            let storageRef = Storage.storage().reference(forURL: "gs://connect-d5e3b.appspot.com").child("profile_image").child(uid!)
            if let profileImage = self.selectedImage, let imageData = profileImage.jpegData(compressionQuality: 0.1) {
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        return
                    }
                    let profileImageURL = metadata?.downloadURL()?.absoluteString
                    
                    setupUserInfo(profileImageURL: profileImageURL!, username: self.usernameTextField.text!, email: self.emailTextField.text!, uid: uid!)
                }
            }
        })
        
        func setupUserInfo(profileImageURL: String, username: String, email: String, uid: String) {
            let ref = Database.database().reference()
            let usersReference = ref.child("users")
            let newUserRef = usersReference.child(uid)
            newUserRef.setValue(["username": username, "email": email, "profileImageURL": profileImageURL])
            self.performSegue(withIdentifier: "signUpToTabBarVC", sender: nil)
        }
   }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("DID FINISH PICKING MEDIA")
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            selectedImage = image
            profilePicture.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
}

