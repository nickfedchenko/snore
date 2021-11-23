//
//  NotificationHelper.swift
//  shonre
//
//  Created by Александр Шендрик on 23.11.2021.
//

import Foundation
import UserNotifications

class NotificationHelper {
    var nc : UNUserNotificationCenter
    
    init(notificationCenter : UNUserNotificationCenter) {
        self.nc = notificationCenter
    }
}
