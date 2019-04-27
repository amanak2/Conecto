//
//  UserUtil.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 28/03/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class UserUtil {
    
    //MARK: save & fetch string
    static func saveString(withValue value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func fetchString(forKey key: String) -> String? {
        let value = UserDefaults.standard.string(forKey: key)
        return value
    }
    
    //MARK: save & fetch Int
    static func saveInt(withValue value: Int, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func fetchInt(forKey key: String) -> Int? {
        let value = UserDefaults.standard.integer(forKey: key)
        return value
    }
    
    //MARK: save & fetch bool
    static func saveBool(withValue value: Bool, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func fetchBool(forKey key: String) -> Bool? {
        let value = UserDefaults.standard.bool(forKey: key)
        return value
    }
    
    
    //MARK: DATE CONVERTER
    static func convert(toDate forUTC: String) -> String {
        let utcTime = forUTC
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: utcTime)
        
        let calender = Calendar.current
        let component = calender.dateComponents([.day , .month , .year], from: date!)
        return "\(component.day!)/\(component.month!)/\(component.year!)"
    }
    
    static func timeAgoInAgo(_ timeUTC: String) -> String? {
        
        let dateStringUTC = timeUTC
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: dateStringUTC)!
        
//        let now = Date()
//        let formatter = DateComponentsFormatter()
//        formatter.calendar?.locale = Locale(identifier: "UTC")
//        formatter.unitsStyle = .brief
//        formatter.maximumUnitCount = 2
//
//        let str = formatter.string(from: date, to: now)! + " ago"
        
        let elapsedTimeInSeconds = NSDate().timeIntervalSince(date as Date)
        let secondInDays: TimeInterval = 60*60*24
        
        if elapsedTimeInSeconds > 7 * secondInDays {
            dateFormatter.dateFormat = "dd/MM/yy"
        } else if elapsedTimeInSeconds > secondInDays {
            dateFormatter.dateFormat = "EEE"
        }
        
        return dateFormatter.string(for: date)
    }
}
