//
//  Date+Ext.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 18/05/2022.
//

import Foundation

public extension Date {
    static let formatMMdd_HHmm = "MM/dd HH:mm"
    static let formatMMddHHmm = "MM-dd HH:mm"
    static let formatddMMHHmm = "dd-MM HH:mm"
    static let formatMMddHHmmss = "MM-dd HH:mm:ss"
    static let formatdd = "dd"
    static let formatMM = "MM"
    static let formatMMDD = "MM/dd"
    static let formatDDMM = "dd/MM"
    static let formatHHmm = "HH:mm"
    static let formatYYYYMMdd = "YYYY/MM/dd"
    static let formatYear = "YYYY"
    
    static let dateTimeZoneFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let dateFormat = "yyyy-MM-dd HH:mm:ss"
    static let dateCompactFormat = "yyyy-MM-dd"
    static let yyyyMMddHHmm = "yyyy-MM-dd HH:mm"
    static let yyMMddHHmm = "yy-MM-dd HH:mm"
    static let mmdd = "MM-dd"
    static let yyyyMMddHHmm2 = "yyyy/MM/dd HH:mm"
    static let formatyyyyMMddHHmmss = "yyyy/MM/dd HH:mm:ss"
    static let formatyyyyMMddTHHmmss = "yyyy/MM/dd'T'HH:mm:ss"
    static let formatddMMyyyyHHmm = "dd-MM-yyyy HH:mm"
    static let formatddMMyyyy = "dd-MM-yyyy"

    static func localizedFormatter(format: String = dateFormat) -> DateFormatter {
        let formatter =  DateFormatter()
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter
    }
    
    static func getDayMonthStyleEvent(date: Date) -> String {
        let calendar = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let dateString = String(format: "%02d", calendar.month ?? 0) + "/" + String(format: "%02d", calendar.day ?? 0)
        return dateString
    }
    
    static func getMonthQuaterStyleEvent(date: Date) -> String {
        let calendar = Calendar.current.dateComponents([.year, .month], from: date)
        let dateString = String(format: "%04d", calendar.year ?? 0) + "/" + String(format: "Q%d", (calendar.month!+2)/3)
        return dateString
    }
    
    static func getDateTime(date: Date, formatDate: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = formatDate
        return dateFormatterGet.string(from: date)
    }
    static func getEventDate(date: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        return dateFormatterGet.string(from: date)
    }
    static func generateTimeStamp() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyMMddHHmmssfff"
        return dateFormatterGet.string(from: Date())
        
    }
    static func generalEventFormat(date: Date, formatDate: String = "dd-MM-YYYY HH:MM") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date)
    }
    static func generalEventDateOurightFormat(date: Date, formatDate: String = "yyyy-MM-dd HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date)
    }
    
    static func dateFromWith(string: String, formatDate: String = dateCompactFormat) -> Date? {
        let dateFormatter = localizedFormatter(format: formatDate)
        return dateFormatter.date(from: string)
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    static func getDates(forLastNDays nDays: Int, formatDate: String = "yyyy-MM-dd") -> [String] {
        let cal = NSCalendar.current
        // start with today
        
        var arrDates = [String]()
        
        for i in 0 ..< nDays {
            var date = cal.startOfDay(for: Date())
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: -i, to: date)!
            
            let dateFormatter = localizedFormatter(format: formatDate)
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        return arrDates
    }
    
    static func getMonth(forLastNMonths nMonths: Int) -> ([String], [String]) {
        let cal = NSCalendar.current
        // start with today
        var arrMonths = [String]()
        var arrMonthsBack = [String]()
        
        var count = 3
        for i in 0 ..< nMonths {
            var date = cal.startOfDay(for: Date())
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.month, value: -i, to: date)!
            
            let dateFormatter = localizedFormatter(format: "yyyy-MM-dd")
            let monthString = dateFormatter.string(from: date)
            
            if count == 3 {
                arrMonths.append(monthString)
                arrMonthsBack.append(getBackMonths(from: date))
                count = 1
            } else {
                count+=1
            }
        }
        
        return (arrMonths, arrMonthsBack)
    }
    
    static func getBackMonths(from month: Date,backMonths:Int = -2) -> String {
        var monthString = ""
        let cal = NSCalendar.current
        let monthBack = cal.date(byAdding: Calendar.Component.month, value: backMonths, to: month)!
        let dateFormatter = localizedFormatter(format: "yyyy-MM-dd")
        monthString = dateFormatter.string(from: monthBack)
        return monthString
    }
    
    func formattedDate(dateFormat: String = dateFormat) -> String {
        let dateFormatter = Date.localizedFormatter(format: dateFormat)
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    static func generateSportCountFormat(date: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy"
        return dateFormatterGet.string(from: date)
    }
    
    static func getDayOfQuater(date: String) -> (startDate: String, endDate: String) {
        let array = date.components(separatedBy: "/Q")
        var startDate = ""
        var endDate = ""
        if array.count > 1 {
            switch array[1] {
            case "1":
                startDate = "\(array[0])" + "-01-01"
                endDate = "\(array[0])" + "-03-31"
            case "2":
                startDate = "\(array[0])" + "-04-01"
                endDate = "\(array[0])" + "-06-30"
            case "3":
                startDate = "\(array[0])" + "-07-01"
                endDate = "\(array[0])" + "-09-30"
            case "4":
                startDate = "\(array[0])" + "-10-01"
                endDate = "\(array[0])" + "-12-31"
            default:
                break
            }
        }
        return (startDate,endDate)
    }
    
    static func today(format : String = "yyyy-MM-dd") -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func getDate(from dateStr: String, format: String) -> Date? {
        let dateFormatter = localizedFormatter(format: format)
        return dateFormatter.date(from: dateStr)
    }
    
    static func convertDate(from dateStr: String, currentFormat: String, newFormat: String) -> String {
        let date = getDate(from: dateStr, format: currentFormat)
        return date?.formattedDate(dateFormat: newFormat) ?? ""
    }
    static func getDateTimeNow(_ format: String = dateFormat) -> String {
        return Date().formattedDate(dateFormat: format)
    }
    static func getDate(forLastNDays nDays: Int) -> Date {
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: Date())
        date = cal.date(byAdding: Calendar.Component.day, value: -nDays, to: date)!
        return date
    }
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    static func getDateCompact() -> String {
        let dateFormatter = localizedFormatter(format: dateCompactFormat)
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    static func getHourData(date: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm:ss"
        return dateFormatterGet.string(from: date)
    }
    
    static func convertTimestampToDateStr(_ interval: Int,
                                          dateFormat: String = "yy-MM-dd HH:mm") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        let format = DateFormatter()
        format.dateFormat = dateFormat
        return format.string(from: date)
    }
}
