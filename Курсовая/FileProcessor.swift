//
//  FileProcessor.swift
//  Курсовая
//
//  Created by Иван on 26.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import Foundation

public class FileProcessor {
    //Путь к папке с документами
    class func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //Путь к файлу Checklist.plist, в котором мы будем хранить наши дела
    class func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    //Сохраняет в файл список дел
    class func saveChecklistItems(items: [ChecklistItem]) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    //Считывает из файла список дел
    class func loadChecklistItems() -> [ChecklistItem] {
        var items = [ChecklistItem]()
        
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            unarchiver.finishDecoding()
        }
        
        return items
    }
    
}
