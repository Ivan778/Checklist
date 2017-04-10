//
//  SignInViewController.swift
//  Курсовая
//
//  Created by Иван on 10.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Делаем UITextField для ввода e-mail скруглённым, а также изменяем его рамку и цвет этой рамки
        emailTextField.layer.cornerRadius = 15.0
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor = UIColor.white.cgColor
        
        //Делаем UITextField для ввода пароля скруглённым, а также изменяем его рамку и цвет этой рамки
        passwordTextField.layer.cornerRadius = 15.0
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        
        //Настраиваем нашу кнопку (делаем её скруглённой и зелёного цвета)
        registerButton.layer.cornerRadius = 15.0
        registerButton.layer.borderWidth = 2.0
        registerButton.layer.borderColor = UIColor.init(red: 0, green: 128, blue: 0, alpha: 0).cgColor
        
        //Делаем так, чтобы клавиатура пряталась по нажатию на что-либо на экране
        self.hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                self.login()
            } else {
                print("User created!")
                self.login()
            }
        }
    }
    
    func login() {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("Problems with signing in!");
            } else {
                print("Signed succesfully!")
            }
        }
    }

}
