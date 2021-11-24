//
//  NotificationHelper.swift
//  shonre
//
//  Created by Александр Шендрик on 23.11.2021.
//

import Foundation
import UserNotifications
import ApphudSDK
import Amplitude

class NotificationHelper : ObservableObject {
    @Published var isAllowed : Bool
    var nc : UNUserNotificationCenter
    let userdefault = UserDefaults.standard
    
    init(notificationCenter : UNUserNotificationCenter) {
        self.nc = notificationCenter
        self.isAllowed = false
    }
    
    func request(){
        Amplitude.instance().logEvent("popuppermishenshown", withEventProperties: ["wasshown": true])
        nc.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.isAllowed = true
                Apphud.setUserProperty(key: .init("nitficationpermissed"), value: self.isAllowed)
//                Amplitude.instance().setValue("true", forKey: "nitficationpermissed")
            } else {
                self.isAllowed = false
                Apphud.setUserProperty(key: .init("nitficationpermissed"), value: self.isAllowed)
//                Amplitude.instance().setValue("false", forKey: "nitficationpermissed")
            }
        }
    }
    
    func set2Hourreqiest(){
        nc.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                if self.userdefault.bool(forKey: "set2HourreqiestSet") == false {
                    let content = UNMutableNotificationContent()
                    content.title = "Испытание открыто!"
                    content.body = "За его прохождение ты получишь 100 моент! Поторопись!"
                    content.categoryIdentifier = "2Hourreqiest"
                    content.sound = UNNotificationSound.default

                    let interval:TimeInterval = 3600.0 * 2
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
                    
                    let request =  UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.nc.add(request)
                    self.userdefault.set(true, forKey: "set2HourreqiestSet")
                }
            }
        }
    }
    
    func del2Hourreqiest(){
        nc.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.nc.removeDeliveredNotifications(withIdentifiers: ["eveningAff"])
                self.userdefault.set(false, forKey: "set2HourreqiestSet")
            }
        }
    }
    
}
