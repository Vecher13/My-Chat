//
//  KeyboardSettings.swift
//  My Chat
//
//  Created by Ash on 24.10.2020.
//

import Foundation
import UIKit



extension UIViewController{
    func hideKeyboardOnTapOnScren(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
                   target: self,
                   action: #selector(self.dismissKeyboard))

               self.view.addGestureRecognizer(tapRecognizer)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class KeyboardSettings{
    
    
    
//    var view: UIView! = nil
    static var app: KeyboardSettings = {
        return KeyboardSettings()
    }()
    
    func hideKeyboardOnTapOnScren(view: UIView){
        
     
        let viewVC = view
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
                   target: self,
                   action: #selector(self.dismissKeyboard))
               
        viewVC.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard(viewVC: UIView) {
        viewVC.endEditing(true)
    }
    
   
}
