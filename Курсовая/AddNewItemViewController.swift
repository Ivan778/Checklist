//
//  AddNewItemViewController.swift
//  Курсовая
//
//  Created by Иван on 14.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import UIKit

protocol AddNewItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: AddNewItemViewController)
    func addItemViewController(_ controller: AddNewItemViewController, didFinishAdding item: ChecklistItem)
}

class AddNewItemViewController: UITableViewController, UITextFieldDelegate {
    //Ссылка на нашу кнопку Добавить
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    //Через неё будем посылать данные для создания новой ячейки
    weak var delegate: AddNewItemViewControllerDelegate?
    
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
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    //Возвращаемся в ChecklistViewController и говорим ему добавить в Table View элемент
    @IBAction func backToChecklistViewControllerAndAddNewItem() {
        //Создаём ячейку
        let item = ChecklistItem()
        item.setText(text: whatToAddTextField.text!)
        
        //Отправляем её
        delegate?.addItemViewController(self, didFinishAdding: item)
    }
    
    //Метод не позволяет нам сделать яейку выбранной (т.е. серого цвета)
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //Метод делает так, чтобы клавиатура автоматически появлялась при переходе на этот View Controller. При этом, клавиатура появится перед тем, как этот View Controller узнает о том, что он сейчас появится
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        whatToAddTextField.becomeFirstResponder()
    }
    
}
