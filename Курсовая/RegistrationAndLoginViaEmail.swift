//
//  RegistrationAndLoginViaEmail.swift
//  Курсовая
//
//  Created by Иван on 25.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import Foundation
import Firebase

public class RegistrationAndLoginViaEmail {
    //Входит в аккаунт пользователя
    class func login(email: String, password: String, viewController: UIViewController, identifier: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                //Сохраняем ID пользователя для последующего использования
                let userID = FIRAuth.auth()?.currentUser?.uid
                SaveUserSignInfo.saveUserID(id: userID!)
                //Сохраняем e-mail и пароль
                SaveUserSignInfo.saveEmailAndPassword(email: email, password: password)
                //Говорим, что мы уже зашли в аккаунт
                SaveUserSignInfo.sayImLoggedIn()
                
                //Выполняем переход в основной ViewController
                viewController.performSegue(withIdentifier: identifier, sender: viewController)
            }
            else {
                print("Проблемы со входом")
                
                //Инициализируем наше сообщение о проблеме со входом
                let alert = UIAlertController(title: "Ошибка!", message: "Проверьте e-mail или пароль.", preferredStyle: .alert)
                //Добавляем ему обработчик (в данном случае он пустой)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                //Устанавливаем обработчик
                alert.addAction(action)
                //Выводим сообщение
                viewController.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    //Регистрирует пользователя и входит в его аккаунт
    class func register(email: String, password: String, viewController: UIViewController, identifier: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            //Если удалось создать аккаунт без ошибок
            if error == nil {
                //Говорим, что мы только создали аккаунт
                SaveUserSignInfo.userHaveJustCreatedNewAccount()
                
                //Заходим в аккаунт
                RegistrationAndLoginViaEmail.login(email: email, password: password, viewController: viewController, identifier: identifier)
                //Если при создании аккаунта есть проблемы
            } else {
                print("Проблемы со входом")
                
                //Инициализируем наше сообщение о проблеме со входом
                let alert = UIAlertController(title: "Ошибка!", message: "Проверьте e-mail.", preferredStyle: .alert)
                //Добавляем ему обработчик (в данном случае он пустой)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                //Устанавливаем обработчик
                alert.addAction(action)
                //Выводим сообщение
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
