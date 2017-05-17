//
//  ChecklistItem.swift
//  Курсовая
//
//  Created by Иван on 13.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    private var text: String = "Новая ячейка"
    private var state: Bool = false
    private var date: Date = Date()
    private var shouldRemind: Bool = false
    
    public func setAll(text: String, state: Bool, date: Date, shouldRemind: Bool) {
        self.text = text
        self.state = state
        self.date = date
        self.shouldRemind = shouldRemind
    }
    
    init(text: String, state: Bool, date: Date, shouldRemind: Bool) {
        self.text = text
        self.state = state
        self.date = date
        self.shouldRemind = shouldRemind
    }
    
    public func resetItem(item: ChecklistItem) {
        self.text = item.getText()
        self.state = item.getState()
        self.date = item.getDate()
        self.shouldRemind = item.getRemind()
    }
    
    public func setText(text: String) {
        self.text = text
    }
    
    public func setState(state: Bool) {
        self.state = state
    }
    
    public func getText() -> String {
        return self.text
    }
    
    public func getState() -> Bool {
        return self.state
    }
    
    public func setInverse() -> Void {
        self.state = !self.state
    }
    
    public func setDate(date: Date) {
        self.date = date
    }
    
    public func getDate() -> Date {
        return date
    }
    
    public func setRemind(shouldRemind: Bool) {
        self.shouldRemind = shouldRemind
    }
    
    public func getRemind() -> Bool {
        return shouldRemind
    }
    
    public func convertChecklistItemToDictionary() -> [String: String] {
        var stateS = "false"
        if state == true {
            stateS = "true"
        }
        
        var remindS = "false"
        if shouldRemind == true {
            remindS = "true"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en")
        
        let dateS = formatter.string(from: date)
        
        return ["text": text, "state": stateS, "remind": remindS, "date": dateS]
        
    }
    
    public func convertItemDictionaryToChecklistItem(dictionary: [String: String]) {
        text = dictionary["text"]!
        
        if ((dictionary["state"]!) == "true") {
            state = true
        } else {
            state = false
        }
        
        if ((dictionary["remind"]!) == "true") {
            shouldRemind = true
        } else {
            shouldRemind = false
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en")
        
        date = formatter.date(from: dictionary["date"]!)!
    }
    
    //Кодирует поля для записи в файл
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(state, forKey: "Checked")
        aCoder.encode(date, forKey: "Date")
        aCoder.encode(shouldRemind, forKey: "Remind")
    }
    
    //Декодирует поля для вычитки из файла
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        state = aDecoder.decodeBool(forKey: "Checked")
        date = aDecoder.decodeObject(forKey: "Date") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "Remind")
        
        super.init()
    }
    
    override init() {
        super.init()
    }
}
