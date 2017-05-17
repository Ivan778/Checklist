//
//  RegisterViewController.swift
//  Курсовая
//
//  Created by Иван on 10.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import UIKit
import Firebase

//Прячет клавиатуру по нажатию на пустое место на экране
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

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Делаем UITextField для ввода e-mail скруглённым, а также изменяем его рамку и цвет этой рамки
        CustomizeUIElements.customizeBounds(element: emailTextField, color: UIColor.white.cgColor)
        //Делаем UITextField для ввода пароля скруглённым, а также изменяем его рамку и цвет этой рамки
        CustomizeUIElements.customizeBounds(element: passwordTextField, color: UIColor.white.cgColor)
        //Настраиваем нашу кнопку (делаем её скруглённой и зелёного цвета)
        CustomizeUIElements.customizeBounds(element: registerButton, color: UIColor.init(red: 0, green: 128, blue: 0, alpha: 0).cgColor)
        
        //Делаем так, чтобы клавиатура пряталась по нажатию на что-либо на экране
        self.hideKeyboardWhenTappedAround()
        
        //Очищаем поля ввода e-mail и пароля
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        
    }
    
    //Создаёт или входит в аккаунт пользователя по нажатию на Зарегистрироваться
    @IBAction func createAccount(sender: AnyObject) {
        //Если есть соединение с интернетом
        if Reachability.isConnectedToNetwork() == true {
            //Регистрируем пользователя, заходим в его аккаунт и осуществляем переход на главный ViewController приложения
            RegistrationAndLoginViaEmail.register(email: emailTextField.text!, password: passwordTextField.text!, viewController: self, identifier: "MyFirstTable")
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
    
    //Следит за нажатием на кнопку "Уже есть аккаунт? Войдите в него"
    @IBAction func pressedSignInButton(_ sender: UIButton) {
        //Осуществляет переход на ViewController со входом в аккаунт
        self.performSegue(withIdentifier: "WantToSignIn", sender: self)
    }

}
