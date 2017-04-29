//
//  SaveUserSignInfo.swift
//  Курсовая
//
//  Created by Иван on 25.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import Foundation

public class SaveUserSignInfo {
    //Сохраняет в UserDefaults пароль и e-mail пользователя
    class func saveEmailAndPassword(email: String, password: String) {
        UserDefaults.standard.setValue(email, forKey: "userEmail")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.setValue(password, forKey: "userPassword")
        UserDefaults.standard.synchronize()
    }
    
    //Сохраняет в UserDefaults информацию о том, что пользователь уже зарегистрировался
    class func sayImLoggedIn() {
        UserDefaults.standard.set(true, forKey: "loggedIn")
        UserDefaults.standard.synchronize()
    }
    
    //Сохраняет в UserDefaults информацию о том, что пользователь уже вышел из аккаунта
    class func sayImLoggedOut() {
        UserDefaults.standard.set(false, forKey: "loggedIn")
        UserDefaults.standard.synchronize()
    }
    
    //Сохраняет в UserDefaults информацию о том, что пользователь создал аккаунт
    class func userHaveJustCreatedNewAccount() {
        UserDefaults.standard.set(true, forKey: "firstTime")
        UserDefaults.standard.synchronize()
    }
    
    //Сохраняет ID пользователя
    class func saveUserID(id: String) {
        UserDefaults.standard.setValue(id, forKey: "UserID")
        UserDefaults.standard.synchronize()
    }
    
    class func userSignedInOldAccount() {
        UserDefaults.standard.set(false, forKey: "firstTime")
        UserDefaults.standard.synchronize()
    }
}
