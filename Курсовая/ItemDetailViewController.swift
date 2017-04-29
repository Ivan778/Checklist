//
//  ItemDetailViewController.swift
//  Курсовая
//
//  Created by Иван on 14.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

//Обнуляет секунды
func resetSeconds(date: Date) -> Date {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    
    //Получили строку из времени
    let dateS = formatter.string(from: date)
    
    //Настроили DateFormatter на строку, из которой ему нужно вытянуть дату
    formatter.dateFormat = "MM dd, yyyy, hh:mm aaa"
    
    return formatter.date(from: dateS)!
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    //Ссылка на нашу кнопку Добавить
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    //Сам DatePicker
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //Переменная для обращения ячейке с DatePicker
    @IBOutlet weak var datePickerCell: UITableViewCell!
    
    //Будет хранить ячейку, которую нужно модифицировать
    var itemToEdit: ChecklistItem?
    
    //Через неё будем посылать данные для создания новой ячейки
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var dueDate = Date()
    
    //Ссылка на UISwich
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    //Ссылка на Label, который будет отображать дату напоминания
    @IBOutlet weak var dueDateLabel: UILabel!
    
    //Флаг, который управляет видимостью DatePicker
    var datePickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Если ItemDetailViewController был открыт для редактирования текущего дела, то подготовим ViewController
        if let item = itemToEdit {
            title = "Изменить"
            whatToAddTextField.text = item.getText()
            addBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.getRemind()
            dueDate = item.getDate()
            
            //Если напоминалка включена
            if item.getRemind() == true {
                //Если дата уже прошла
                if Date() > item.getDate() {
                    //То отключаем напоминание
                    item.setRemind(shouldRemind: false)
                    shouldRemindSwitch.isOn = item.getRemind()
                }
            }
            
        }
        updateDueDateLabel()
    }
    
    //Изменяет текст Label, который отображает дату
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    ///////////////////////////////////Работа с ячейкой DatePicker////////////////////////////////////////////////////////
    
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        whatToAddTextField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    //Как только пользователь начинает вводить текст, прячем DatePicker
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        datePicker.setDate(dueDate, animated: false)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    //Один из методов-делегатов UITextField. Вызывается каждый раз, как пользователь вводит что-либо в поле для ввода
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        //Если есть текст, то делаем кнопку нажимаемой (true)
        addBarButton.isEnabled = (newText.length > 0)
        
        return true
        
    }
    
    //Ссылка на наш TextField с названием ячейки, которую нужно добавить
    @IBOutlet weak var whatToAddTextField: UITextField!
    
    //Просто возвращаемся в ChecklistViewController
    @IBAction func backToChecklistViewController() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    //Возвращаемся в ChecklistViewController и говорим ему добавить в Table View элемент
    @IBAction func backToChecklistViewControllerAndAddNewItem() {
        if let item = itemToEdit {
            //Создали новый элемент списка (изменённый, если быть точнее)
            let newChecklistItem = ChecklistItem(text: whatToAddTextField.text!, state: item.getState(), date: resetSeconds(date: dueDate), shouldRemind: shouldRemindSwitch.isOn)
            
            //Установили локальное уведомление
            let setNotification = SettingLocalNotifications()
            setNotification.resetNotification(oldItem: item, newItem: newChecklistItem)
            
            //Изменили старую ячейку
            item.resetItem(item: newChecklistItem)
            
            //Отправили изменённую старую ячейку обратно в ChecklistViewController
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            //Создали новый элемент списка
            let newChecklistItem = ChecklistItem(text: whatToAddTextField.text!, state: false, date: resetSeconds(date: dueDate), shouldRemind: shouldRemindSwitch.isOn)
            
            //Установили локальное уведомление
            let setNotification = SettingLocalNotifications()
            setNotification.setNotification(text: newChecklistItem.getText(), date: newChecklistItem.getDate())
 
            //Отправляем новый элемент в ChecklistViewController
            delegate?.itemDetailViewController(self, didFinishAdding: newChecklistItem)
        }
    }
    
    //Метод не позволяет нам сделать ячейку выбранной (т.е. серого цвета)
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    //Метод делает так, чтобы клавиатура автоматически появлялась при переходе на этот View Controller. При этом, клавиатура появится перед тем, как этот View Controller узнает о том, что он сейчас появится
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        whatToAddTextField.becomeFirstResponder()
    }
    
}
