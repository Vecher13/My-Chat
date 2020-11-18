//
//  SignInViewController.swift
//  My Chat
//
//  Created by Ash on 23.10.2020.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            hideKeyboardOnTapOnScren()
//        let keyboardsetings = KeyboardSettings()
//        keyboardsetings.hideKeyboardOnTapOnScren(view: view)
        // Do any additional setup after loading the view.
    }
    @IBAction func ChatInTapped(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error{
                print(error.localizedDescription)
                    } else {
                        self.performSegue(withIdentifier: "LogInToChat", sender: self)
                    }
            }
          
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
