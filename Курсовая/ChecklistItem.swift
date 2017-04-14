//
//  ChecklistItem.swift
//  Курсовая
//
//  Created by Иван on 13.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import Foundation

class ChecklistItem {
    private var text: String = "Новая ячейка"
    private var state: Bool = false
    
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
}
