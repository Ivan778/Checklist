//
//  ViewController.swift
//  Курсовая
//
//  Created by Иван on 07.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

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
        return 100
    }
    
    //Этот метод даёт данные для TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        //Получаем ячейку из таблицы (а точнее Label этой ячейки, т.к. её tag = 1000)
        let label = cell.viewWithTag(1000) as! UILabel
        
        /*
        //Здесь мы просто заполняем ячейки текстом (для каждой ячейки свой текст)
        switch (indexPath.row) {
            case 0: label.text = "Погулять с собакой"; break
            case 1: label.text = "Поработать над курсачом"; break
            case 2: label.text = "Помыть посуду"; break
            case 3: label.text = "Сделать лабу"; break
            case 4: label.text = "Купить кабель"; break
            default: break
        }
        */
        
        if indexPath.row % 5 == 0 {
            label.text = "Погулять с собакой"
        } else if indexPath.row % 5 == 1 {
            label.text = "Поработать над курсачом"
        } else if indexPath.row % 5 == 2 {
            label.text = "Помыть посуду"
        } else if indexPath.row % 5 == 3 {
            label.text = "Сделать лабу"
        } else if indexPath.row % 5 == 4 {
            label.text = "Купить кабель"
        }
        
        return cell
    }
    
    //Метод следит за нажатиями на элементы TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        
        //Если мы нажали на элемент, он становится серым. Чтобы убрать этот эффект, воспользуемся следующим методом
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

