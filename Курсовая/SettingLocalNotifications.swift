//
//  SettingLocalNotifications.swift
//  Курсовая
//
//  Created by Иван on 22.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import UIKit

class SettingLocalNotifications {
    private let notification = UILocalNotification()
    
    func setNotification(text: String, date: Date) {
        notification.alertTitle = text
        notification.alertBody = text
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = date
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    //Метод будет переопределять старое локальное уведомление
    func resetNotification(oldItem: ChecklistItem, newItem: ChecklistItem) {
        //Если требуется отменить уведомление
        if (oldItem.getRemind() == true && newItem.getRemind() == false) {
            //Ищем это уведомление и удаляем его
            for oneEvent in UIApplication.shared.scheduledLocalNotifications! {
                let ntfc = oneEvent as UILocalNotification
                if (ntfc.alertBody == oldItem.getText() && ntfc.fireDate == oldItem.getDate()) {
                    UIApplication.shared.cancelLocalNotification(ntfc)
                    return
                }
            }
        }
        
        //Если уведомление просто изменили
        if (oldItem.getRemind() == true && newItem.getRemind() == true) {
            //Ищем старое уведомление и удаляем его
            for oneEvent in UIApplication.shared.scheduledLocalNotifications! {
                let ntfc = oneEvent as UILocalNotification
                if (ntfc.alertBody == oldItem.getText() && ntfc.fireDate == oldItem.getDate()) {
                    UIApplication.shared.cancelLocalNotification(ntfc)
                }
            }
            //Устанавливаем новое уведомление
            setNotification(text: newItem.getText(), date: newItem.getDate())
            return
        }
        
        //Если пользователь просто хочет установить уведомление
        if (oldItem.getRemind() == false && newItem.getRemind() == true) {
            setNotification(text: newItem.getText(), date: newItem.getDate())
            return
        }
    }
    
    //Проверяет наличие локального уведомления в списке локальных уведомлений
    func isLocalNotificationIsOnOf(item: ChecklistItem) -> Bool {
        //Запускаем цикл поиска уведомления
        for oneEvent in UIApplication.shared.scheduledLocalNotifications! {
            let event = oneEvent as UILocalNotification
            //Если имя и дата найденного уведомления совпадают с имененм и датой текущего элемента
            if (event.alertBody == item.getText() && event.fireDate == item.getDate()) {
                //Возвращаем true
                return true
            }
        }
        //В противном случае возвращаем false
        return false
    }
    
}
