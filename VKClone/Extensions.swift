//
//  Extensions.swift
//  VKClone
//
//  Created by Alexander Blokhin on 18.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import Foundation


extension String {
    mutating func valueForTag(tag: String, close: String) -> String {
        
        let start = self.rangeOfString(tag)?.endIndex
        
        self = self.substringFromIndex(start!)
        
        if close.isEmpty {
            return self
        }
        
        let startClose = self.rangeOfString(close)?.startIndex
        let endClose = self.rangeOfString(close)?.endIndex
        
        let value = self.substringToIndex(startClose!)
        
        self = self.substringFromIndex(endClose!)

        
        return value
    }
}


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        switch yearsFrom(date) {
        case 1: return "год назад"
        case 2: return "два года назад"
        case 3: return "три года назад"
        case 4: return "четыре года назад"
        case 5: return "пять лет назад"
        case 6: return "шесть лет назад"
        default: break
        }
        
        switch monthsFrom(date) {
        case 1: return "месяц назад"
        case 2: return "два месяца назад"
        case 3: return "три месяца назад"
        case 4: return "четыре месяца назад"
        case 5: return "пять месяцев назад"
        case 6: return "шесть месяцев назад"
        case 7: return "семь месяцев назад"
        case 8: return "восемь месяцев назад"
        case 9: return "девять месяцев назад"
        case 10: return "десять месяцев назад"
        case 11: return "одиннадцать месяцев назад"
        default: break
        }

        switch weeksFrom(date) {
        case 1: return "одну неделю назад"
        case 2: return "две недели назад"
        case 3: return "три недели назад"
        case 4: return "четыре недели назад"
        case 5: return "пять недель назад"
        default: break
        }
        
        switch daysFrom(date) {
        case 1: return "вчера"
        case 2: return "два дня назад"
        case 3: return "три дня назад"
        case 4: return "четыре дня назад"
        case 5: return "пять дней назад"
        case 6: return "шесть дней назад"
        default: break
        }

        switch hoursFrom(date) {
        case 1: return "час назад"
        case 2: return "два часа назад"
        case 3: return "три часа назад"
        case 4: return "четыре часа назад"
        case 5...20: return "\(hoursFrom(date)) часов назад"
        case 21: return "\(hoursFrom(date)) час назад"
        case 22...24: return "\(hoursFrom(date)) часа назад"
        default: break
        }
        
        switch minutesFrom(date) {
        case 1: return "минуту назад"
        case 2: return "две минуты назад"
        case 3: return "три минуты назад"
        case 4: return "четыре минуты назад"
        case 5...20, 25...30, 35...40, 45...50, 55...60: return "\(minutesFrom(date)) минут назад"
        case 21, 31, 41, 51: return "\(minutesFrom(date)) минуту назад"
        case 22...24, 32...34, 42...44, 52...54: return "\(minutesFrom(date)) минуты назад"
        default: break
        }
        
        switch secondsFrom(date) {
        case 1: return "секунду назад"
        case 2: return "две секунды назад"
        case 3: return "три секунды назад"
        case 4: return "четыре секунды назад"
        case 5...20, 25...30, 35...40, 45...50, 55...60: return "\(secondsFrom(date)) секунд назад"
        case 21, 31, 41, 51: return "\(secondsFrom(date)) секунду назад"
        case 22...24, 32...34, 42...44, 52...54: return "\(secondsFrom(date)) секунды назад"
        default: break
        }
        
        return ""
    }
    
    
}









