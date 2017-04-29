//
//  ViewController.swift
//  Курсовая
//
//  Created by Иван on 07.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    //Объявили массив для хранения элементов таблицы
    var items: [ChecklistItem]
    
    //Ссылка на базу данных
    var databaseReference: FIRDatabaseReference!
    
    var toDoWrite = WriteToDataBase()
    
    //Инициализируем наш массив с делами
    required init?(coder aDecoder: NSCoder) {
        //Создали массив
        items = [ChecklistItem]()
        
        super.init(coder: aDecoder)
        
        //Подгружаем список дел в массив items
        //loadChecklistItems()
        items = FileProcessor.loadChecklistItems()
        
        //Используем этот блок для загрузки данных уже зарегистрированного пользователя при его первом входе в систему
        if UserDefaults.standard.bool(forKey: "firstTime") == false {
            if Reachability.isConnectedToNetwork() == true {
                //Создали ссылку на данные пользователя
                let ref = FIRDatabase.database().reference().child(UserDefaults.standard.string(forKey: "UserID")!)
                //Теперь получим количество данных пользователя, т.к. оно по моему усмотрению будет писаться в нулевую ноду
                ref.child("0").observeSingleEvent(of: .value, with: { (snapshot) in
                    //Получаем данные пользователя
                    let value = snapshot.value as? NSDictionary
                    //Извлекаем из них требуемое количество данных
                    let amountOfNodes = (Int(value?["amount"] as? String ?? "0"))!
                    
                    //Извлекает данные из базы данных по их номерам, записывает их на устройство и выводит на экран
                    var i = 1
                    while (i < (amountOfNodes + 1)) {
                        self.getDataByNumber(number: i)
                        i += 1
                    }
                    
                }) { (error) in
                    print("Hello \(error.localizedDescription)")
                }
            }
            
            UserDefaults.standard.set(true, forKey: "firstTime")
            UserDefaults.standard.synchronize()
            
        }
        
        //print("Document's folder is \(documentsDirectory())")
        //print("Data file path is \(dataFilePath())")
        
    }
    
    //Говорим ItemDetailViewController (перед тем как перейти на него), что принимать сообщение будем мы. Также используется для того, чтобы при выходе из аккаунта записать в UserDefaults информацию о том, что пользователь вышел
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Если требуется добавить новый элемент
        if segue.identifier == "AddItem" {
            //Чтобы получить требуемый ItemDetailViewController, мы сначала проходим через его NavigationController
            let navigationController = segue.destination as! UINavigationController
            //Получаем ссылку на активный ViewController в NavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            //Теперь, имея ссылку на ItemDetailViewController, говорим ему, что ChecklistViewController (self) и есть получатель
            controller.delegate = self
        }
        //Если же требуется модифицировать текущий
        else if segue.identifier == "EditItem" {
            //Чтобы получить требуемый ItemDetailViewController, мы сначала проходим через его NavigationController
            let navigationController = segue.destination as! UINavigationController
            //Получаем ссылку на активный ViewController в NavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            //Теперь, имея ссылку на ItemDetailViewController, говорим ему, что ChecklistViewController (self) и есть получатель
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
        //Если выходим из аккаунта
        else if segue.identifier == "logOutSegue" {
            //Записываем в UserDefaults, что пользователь вышел из аккаунта, т.е. при последующем входе в приложение входной точкой будет RegisterViewController
            SaveUserSignInfo.sayImLoggedOut()
            
            //Т.к. нас перекинет на окно регистрации, то говорим, что пользователь будет входить в первый раз
            SaveUserSignInfo.userHaveJustCreatedNewAccount()
            
            //Очищаем файл от данных пользователя (записываем в файл пустой массив ChecklistItem)
            FileProcessor.saveChecklistItems(items: [ChecklistItem]())
        }
        
        
    }
    
    //Просто возвращаемся назад в ChecklistViewController
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Добавляет элемент в таблицу
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        //Просто добавив элемент в массив с ячейками, мы не отобразим изменения в таблицы
        items.append(item)
        
        //Поэтому мы сообщаем ей об этом
        tableView.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: .automatic)
        
        dismiss(animated: true, completion: nil)
        //saveChecklistItems()
        FileProcessor.saveChecklistItems(items: items)
        
        if Reachability.isConnectedToNetwork() {
            toDoWrite.write()
        }
    }
    
    //Изменяет текст текущей ячейки
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        //Если мы можем получить индекс элемента как у пришедшего элемента
        if let index = items.index(of: item) {
            //Получаем индекс этого элемента в таблице
            let indexPath = IndexPath(row: index, section: 0)
            //Если можно получить доступ к этой ячейке
            if let cell = tableView.cellForRow(at: indexPath) {
                //То изменяем в ней текст
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        //saveChecklistItems()
        FileProcessor.saveChecklistItems(items: items)
        
        if Reachability.isConnectedToNetwork() {
            //toDoWrite.write()
            toDoWrite.rewriteItem(item: item, number: items.index(of: item)!)
        }
    }
    
    //Функция обращается к базе данных и получает из неё информацию
    func getDataByNumber(number: Int) {
        //Ссылка на ноду пользователя (нода пользователя - нода с его ID)
        let ref = FIRDatabase.database().reference().child(UserDefaults.standard.string(forKey: "UserID")!)
        
        //Этот метод извлекает из базы данные по ноде
        ref.child(String(number)).observeSingleEvent(of: .value, with: { (snapshot) in
            //Извлекаем из базы данных словарь с данными
            let value = snapshot.value as? NSDictionary
            
            var dictionary = [String: String]()
            
            //Записываем это в здешний словарь (по думаю, зачем это делать, по сути, можно отправлять уже существующий)
            dictionary.updateValue(value?["text"] as? String ?? "EDFDBProblem", forKey: "text")
            dictionary.updateValue(value?["state"] as? String ?? "", forKey: "state")
            dictionary.updateValue(value?["remind"] as? String ?? "", forKey: "remind")
            dictionary.updateValue(value?["date"] as? String ?? "", forKey: "date")
            
            //Проверяем, не пустой ли он, а то мало ли, извлекли по ошибочному индексу
            if dictionary["text"] != "EDFDBProblem" {
                //Будет хранить полученную ячейку для её последующей отправки в таблицу и в файл
                let item = ChecklistItem()
                
                //Если всё нормально, то конвертируем словарь в ChecklistItem
                //item = self.convertItemDictionaryToChecklistItem(dictionary: dictionary)
                
                //Получили ChecklistItem из словаря
                item.convertItemDictionaryToChecklistItem(dictionary: dictionary)
                
                //Добавляем полученный элемент в массив, из которого TableView берёт значения
                self.items.append(item)
                //Вычисляем индекс, по которому этот элемент был записан в словарь
                let row = self.items.count - 1
                
                //Вставляем ячейку в таблицу
                self.tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                //Сохраняем полученное значение в наш документ
                //self.saveChecklistItems()
                FileProcessor.saveChecklistItems(items: self.items)
                
                //Получили доступ к этой ячейке
                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0))
                //Вывели галочку в ячейке, если это нужно
                self.configureCheckmark(for: cell!, with: item)
                
                let notification = SettingLocalNotifications()
                
                //Если у полученного элемента дата позже текущей даты и оно установлено на выполнение
                if ((item.getDate() > Date()) && (item.getRemind() == true)) {
                    //Проверяем, установлено ли оно
                    if notification.isLocalNotificationIsOnOf(item: item) == false {
                        //Если оно не установлено, то установливаем его
                        notification.setNotification(text: item.getText(), date: item.getDate())
                    }
                }
            }
            
        }) { (error) in
            print("Hello \(error.localizedDescription)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //Этот метод говорит TableView, сколько всего ячеек будет получено
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //Этот метод даёт данные для TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        //Получаем ячейку из таблицы (а точнее Label этой ячейки, т.к. её tag = 1000)
        let label = cell.viewWithTag(1000) as! UILabel
        
        //Устанавливаем текст i-ой ячейки
        label.text = items[indexPath.row].getText()
        
        //Отображаем изменения на экране с помощью этого метода
        configureCheckmark(for: cell, with: items[indexPath.row])
        
        //Отображаем изменение текста
        configureText(for: cell, with: items[indexPath.row])
        
        return cell
    }
    
    //Метод следит за нажатиями на элементы TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            //Устанавливаем инверсное состояние ячейки
            items[indexPath.row].setInverse()
            
            //Отображаем изменения на экране
            configureCheckmark(for: cell, with: items[indexPath.row])
            
            toDoWrite.writeCheckInfo(item: items[indexPath.row], number: indexPath.row)
        }
        
        //Если мы нажали на элемент, он становится серым. Чтобы убрать этот эффект, воспользуемся следующим методом
        tableView.deselectRow(at: indexPath, animated: true)
        
        //saveChecklistItems()
        FileProcessor.saveChecklistItems(items: items)
    }
    
    //Метод следит за отображением галочек напротив текста каждой ячейки таблицы
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        //Получили доступ к Label с нашей галочкой
        let label = cell.viewWithTag(1001) as! UILabel
        
        //Выводим галочку, если это нужно
        if item.getState() == true {
            label.text = "√"
        }
        else {
            label.text = ""
        }
    }
    
    //Метод изменяет текст каждой ячейки таблицы
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        //Получили доступ к Label с нашей галочкой
        let label = cell.viewWithTag(1000) as! UILabel
        
        label.text = item.getText()
    }
    
    //Метод удаляет элемент из таблицы по свайпу
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        //Если мы пользователь хотел, чтобы ему напомнили об этом событии, то удалим его из центра уведомлений
        if item.getRemind() == true && item.getDate() < Date() {
            for oneEvent in UIApplication.shared.scheduledLocalNotifications! {
                let notification = oneEvent as UILocalNotification
                if notification.fireDate == item.getDate() && notification.alertTitle == item.getText() {
                    UIApplication.shared.cancelLocalNotification(notification)
                    break;
                }
            }
        }
        
        //Сначала удаляем элемент из массива с элементами
        items.remove(at: indexPath.row)
        
        //Говорим таблице о том, что нужно удалить элемент
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        //Сохраняем изменения в файле
        //saveChecklistItems()
        FileProcessor.saveChecklistItems(items: items)
        
        //Если есть соединение с интернетом, перезаписываем таблицу на сервере
        if Reachability.isConnectedToNetwork() {
            toDoWrite.write()
        }
    }
    
}
