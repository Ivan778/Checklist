//
//  ViewController.swift
//  Курсовая
//
//  Created by Иван on 07.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import UIKit
import Firebase

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
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
    
    //Говорим ItemDetailViewController (перед тем как перейти на него), что принимать сообщение будем мы
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
        }
        
        //Если мы нажали на элемент, он становится серым. Чтобы убрать этот эффект, воспользуемся следующим методом
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    //Метод изменяет текста каждой ячейки таблицы
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        //Получили доступ к Label с нашей галочкой
        let label = cell.viewWithTag(1000) as! UILabel
        
        label.text = item.getText()
    }
    
    //Метод удаляет элемент из таблицы по свайпу
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //Сначала удаляем элемент из массива с элементами
        items.remove(at: indexPath.row)
        
        //Говорим таблице о том, что нужно удалить элемент
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}

