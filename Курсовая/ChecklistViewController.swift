//
//  ViewController.swift
//  Курсовая
//
//  Created by Иван on 07.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import UIKit
import Firebase

class ChecklistViewController: UITableViewController {
    //Объявили массив для хранения элементов таблицы
    var items: [ChecklistItem]
    
    //Инициализируем наш массив с делами
    required init?(coder aDecoder: NSCoder) {
        //Создали массив
        items = [ChecklistItem]()
        
        let row0Text = ChecklistItem()
        row0Text.setText(text: "Выбить ковры")
        items.append(row0Text)
        
        let row1Text = ChecklistItem()
        row1Text.setText(text: "Прочитать книгу до 90 страницы")
        items.append(row1Text)
        
        let row2Text = ChecklistItem()
        row2Text.setText(text: "Помыть ванную")
        items.append(row2Text)
        
        let row3Text = ChecklistItem()
        row3Text.setText(text: "Повторить схемотехнику")
        items.append(row3Text)
        
        let row4Text = ChecklistItem()
        row4Text.setText(text: "Сделать 4-ую лабу по Java")
        items.append(row4Text)
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        return cell
    }
    
    //Метод следит за нажатиями на элементы TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            //Устанавливаем инверсное состояние ячейки
            items[indexPath.row].setInverse()
            
            //Отображаем изменения на экране
            configureCheckmark(for: cell, with: items[indexPath.row])
        }
        
        //Если мы нажали на элемент, он становится серым. Чтобы убрать этот эффект, воспользуемся следующим методом
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        //Выводим галочку, если это нужно
        if item.getState() == true {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
    }
    
    @IBAction func logOut(sender: AnyObject) {
        UserDefaults.standard.set(false, forKey: "loggedIn")
        dismiss(animated: true, completion: nil)
    }
    
}

