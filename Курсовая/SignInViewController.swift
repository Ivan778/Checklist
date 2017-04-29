//
//  SignInViewController.swift
//  Курсовая
//
//  Created by Иван on 25.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import Foundation
import Firebase

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Делаем UITextField для ввода e-mail скруглённым, а также изменяем его рамку и цвет этой рамки
        CustomizeUIElements.customizeBounds(element: emailTextField, color: UIColor.white.cgColor)
        //Делаем UITextField для ввода пароля скруглённым, а также изменяем его рамку и цвет этой рамки
        CustomizeUIElements.customizeBounds(element: passwordTextField, color: UIColor.white.cgColor)
        //Настраиваем нашу кнопку (делаем её скруглённой и зелёного цвета)
        CustomizeUIElements.customizeBounds(element: signInButton, color: UIColor.init(red: 0, green: 128, blue: 0, alpha: 0).cgColor)
        
        //Делаем так, чтобы клавиатура пряталась по нажатию на что-либо на экране
        self.hideKeyboardWhenTappedAround()
        
        //Очищаем поля ввода e-mail и пароля
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    @IBAction func pressedSignInButton(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            RegistrationAndLoginViaEmail.login(email: emailTextField.text!, password: passwordTextField.text!, viewController: self, identifier: "MyFirstTableFromSignIn")
            SaveUserSignInfo.userSignedInOldAccount()
        }
        //Если же соединения с интернетом нет
        else {
            //Инициализируем наше сообщение об отсутствии интернета
            let alert = UIAlertController(title: "Ошибка!", message: "Проверьте соединение с интернетом.", preferredStyle: .alert)
            //Добавляем ему обработчик (в данном случае он пустой)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            //Устанавливаем обработчик
            alert.addAction(action)
            //Выводим сообщение
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func pressedBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
