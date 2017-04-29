//
//  CustomizeUIElements.swift
//  Курсовая
//
//  Created by Иван on 25.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import Foundation
import UIKit

public class CustomizeUIElements {
    class func customizeBounds(element: UIControl, color: CGColor) {
        element.layer.cornerRadius = 15.0
        element.layer.borderWidth = 2.0
        element.layer.borderColor = color
    }
}
