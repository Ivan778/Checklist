//
//  WriteToDataBase.swift
//  Курсовая
//
//  Created by Иван on 21.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class WriteToDataBase {
    //Ссылка на ноду пользователя
    private let userDatabaseReference = FIRDatabase.database().reference().child(UserDefaults.standard.string(forKey: "UserID")!)
    
    //Путь к папке с документами
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //Этот метод перезаписывает всё. Вызывается, если интернета не было и мы обновляем данные
    public func write() {
        //Во первых, проверим, а залогинился ли он, мало ли, только скачал приложение
        if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            //После этого проверим, есть ли соединение с сетью
            if Reachability.isConnectedToNetwork() == true {
                //Путь к файлу, откуда читать информацию
                let path = documentsDirectory().appendingPathComponent("Checklist.plist")
                
                //Сюда поместим считанную информацию
                var items = [ChecklistItem]()
                //Если что-то есть в файле
                if let data = try? Data(contentsOf: path) {
                    //Распарсим это
                    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                    //Отправим это в наш массив как массив типа ChecklistItem
                    items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
                    unarchiver.finishDecoding()
                    
                    //Удаляем старую информацию
                    userDatabaseReference.removeValue()
                    
                    //Отправляем туда количество данных (чтобы потом было легче извлекать)
                    userDatabaseReference.child("0").setValue(["amount" : String(items.count)])
                    
                    var i: Int = 1
                    
                    while (i <= items.count) {
                        //Отправляем на сервер наш элемент
                        userDatabaseReference.child(String(i)).setValue(items[i-1].convertChecklistItemToDictionary())
                        i += 1
                    }
                    
                }
                
            }
        }
    }
    
    //Записывает в базу данных состояние элемента таблицы (отмечено галочкой или нет)
    public func writeCheckInfo(item: ChecklistItem, number: Int) {
        //Во первых, проверим, а залогинился ли он, мало ли, только скачал приложение
        if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            //После этого проверим, есть ли соединение с сетью
            if Reachability.isConnectedToNetwork() == true {
                //Отправляем туда количество данных (чтобы потом было легче извлекать)
                var state = "false"
                if item.getState() == true {
                    state = "true"
                }
                userDatabaseReference.child(String(number+1)).child("state").setValue(state)
            }
        }
    }
    
    public func rewriteItem(item: ChecklistItem, number: Int) {
        //Во первых, проверим, а залогинился ли он, мало ли, только скачал приложение
        if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            //После этого проверим, есть ли соединение с сетью
            if Reachability.isConnectedToNetwork() == true {
                //Записываем в элемент по адресу
                userDatabaseReference.child(String(number+1)).setValue(item.convertChecklistItemToDictionary())
            }
        }
    }
    
}
