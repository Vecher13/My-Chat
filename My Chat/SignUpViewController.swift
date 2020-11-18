//
//  SignUpViewController.swift
//  My Chat
//
//  Created by Ash on 23.10.2020.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var checkOutPasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        hideKeyboardOnTapOnScren()
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    

    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, password == checkOutPasswordTextField.text{
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                //Navigate to the ChatVC
                self.performSegue(withIdentifier: "RegisterToChat", sender: self)
            }
            }
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
          // if keyboard size is not available for some reason, dont do anything
          return
        }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
      }

      @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
        
        // reset back the content inset to zero after keyboard is gone
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
      }

 
}

extension SignUpViewController: UITextFieldDelegate {
   
    func textFieldDidEndEditing(_ textField: UITextField) {
      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

            if let nextResponder = textField.superview?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                print("kuku")
            }

            return true
    }
    
}

extension SignUpViewController{
    
   
    
//    func hideKeyboardOnTapOnScren(){
//        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
//                   target: self,
//                   action: #selector(SignUpViewController.dismissKeyboard))
//
//               self.view.addGestureRecognizer(tapRecognizer)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//
}

