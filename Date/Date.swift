// The MIT License (MIT)
//
// Copyright (c) 2015 Suyeol Jeon (xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation


// MARK: - Initializing with date components

public extension Foundation.Date {

    public init(year: Int, month: Int, day: Int, hours: Int, minutes: Int, seconds: Double) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hours
        components.minute = minutes
        components.second = Int(seconds)
        components.nanosecond = Int((seconds - floor(seconds)) * 1_000_000_000)
        let interval = Calendar.current.date(from: components)?.timeIntervalSinceReferenceDate ?? 0
        self.init(timeIntervalSinceReferenceDate: interval)
    
    }

    public init(year: Int, month: Int, day: Int) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        let interval = Calendar.current.date(from: components)?.timeIntervalSinceReferenceDate ?? 0
        self.init(timeIntervalSinceReferenceDate: interval)
    }

    public init(hours: Int, minutes: Int, seconds: Double) {
        var components = DateComponents()
        components.hour = hours
        components.minute = minutes
        components.second = Int(seconds)
        components.nanosecond = Int((seconds - floor(seconds)) * 1_000_000_000)
        let interval = Calendar.current.date(from: components)?.timeIntervalSinceReferenceDate ?? 0
        self.init(timeIntervalSinceReferenceDate: interval)
    }

    public static func date(_ year: Int, _ month: Int, _ day: Int) -> Foundation.Date {
        return Foundation.Date(year: year, month: month, day: day)
    }

    public static func time(_ hours: Int, _ minutes: Int, _ seconds: Double) -> Foundation.Date {
        return Foundation.Date(hours: hours, minutes: minutes, seconds: seconds)
    }

}


// MARK: - Extracting date

public extension Foundation.Date {

    public var date: Foundation.Date {
        return Foundation.Date(year: self.year, month: self.month, day: self.day)
    }

    public static var today: Foundation.Date {
        return Foundation.Date().date
    }

}


// MARK: - Setter and getters for date components

public extension Foundation.Date {

    public var year: Int { return self.components(.year).year! }
    public var month: Int { return self.components(.month).month! }
    public var day: Int { return self.components(.day).day! }
    public var hours: Int { return self.components(.hour).hour! }
    public var minutes: Int { return self.components(.minute).minute! }
    public var seconds: Double {
        let components = self.components([.second, .nanosecond])
        return Double(components.second!) + Double(components.nanosecond!) / 1_000_000_000
    }
    public var weekday: Int { return self.components(.weekday).weekday! }

    public func withYear(_ year: Int) -> Foundation.Date {
        return Foundation.Date(year: year, month: month, day: day, hours: hours, minutes: minutes, seconds: seconds)
    }

    public func withMonth(_ month: Int) -> Foundation.Date {
        return Foundation.Date(year: year, month: month, day: day, hours: hours, minutes: minutes, seconds: seconds)
    }

    public func withDay(_ day: Int) -> Foundation.Date {
        return Foundation.Date(year: year, month: month, day: day, hours: hours, minutes: minutes, seconds: seconds)
    }

    public func withHours(_ hours: Int) -> Foundation.Date {
        return Foundation.Date(year: year, month: month, day: day, hours: hours, minutes: minutes, seconds: seconds)
    }

    public func withMinutes(_ minutes: Int) -> Foundation.Date {
        return Foundation.Date(year: year, month: month, day: day, hours: hours, minutes: minutes, seconds: seconds)
    }

    public func withSeconds(_ seconds: Double) -> Foundation.Date {
        return Foundation.Date(year: year, month: month, day: day, hours: hours, minutes: minutes, seconds: seconds)
    }

    public func withWeekday(_ weekday: Int) -> Foundation.Date! {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .weekday], from: self)
        components.day = components.day! + (weekday - components.weekday!)
        return calendar.date(from: components)!
    }

    fileprivate func components(_ units: NSCalendar.Unit) -> DateComponents {
        return (Calendar.current as NSCalendar).components(units, from: self)
    }

}


// MARK: - Relative datetime

public extension IntegerLiteralType {

    public var years: _DateTimeDelta { return _DateTimeDelta(self, .year) }
    public var months: _DateTimeDelta { return _DateTimeDelta(self, .month) }
    public var days: _DateTimeDelta { return _DateTimeDelta(self, .day) }

    public var hours: _DateTimeDelta { return _DateTimeDelta(self, .hour) }
    public var minutes: _DateTimeDelta { return _DateTimeDelta(self, .minute)  }
    public var seconds: _DateTimeDelta { return _DateTimeDelta(self, .second) }

    public var year: _DateTimeDelta { return self.years }
    public var month: _DateTimeDelta { return self.months }
    public var day: _DateTimeDelta { return self.days }

    public var hour: _DateTimeDelta { return self.hours }
    public var minute: _DateTimeDelta { return self.minutes }
    public var second: _DateTimeDelta { return self.seconds }

}

public extension FloatLiteralType {

    public var seconds: _DateTimeDelta { return _DateTimeDelta(self, .second) }
    public var second: _DateTimeDelta { return self.seconds }

}

public struct _DateTimeDelta {

    public var value: TimeInterval
    public var unit: Calendar.Component

    public init(_ value: TimeInterval, _ unit: Calendar.Component) {
        self.value = value
        self.unit = unit
    }

    public init(_ value: IntegerLiteralType, _ unit: Calendar.Component) {
        self.init(TimeInterval(value), unit)
    }

    fileprivate var negativeDelta: _DateTimeDelta {
        return type(of: self).init(-self.value, self.unit)
    }


    public func after(_ date: Foundation.Date) -> Foundation.Date {
        switch self.unit {
        case Calendar.Component.year: return date.withYear(date.year + Int(self.value))
        case Calendar.Component.month: return date.withMonth(date.month + Int(self.value))
        case Calendar.Component.day: return date.withDay(date.day + Int(self.value))
        case Calendar.Component.hour: return date.withHours(date.hours + Int(self.value))
        case Calendar.Component.minute: return date.withMinutes(date.minutes + Int(self.value))
        case Calendar.Component.second: return date.withSeconds(date.seconds + self.value)
        default: return date
        }
    }

    public func before(_ date: Foundation.Date) -> Foundation.Date {
        return self.negativeDelta.after(date)
    }

    public var fromNow: Foundation.Date {
        return self.after(Foundation.Date())
    }

    public var ago: Foundation.Date {
        return self.negativeDelta.fromNow
    }

}

public func + (date: Foundation.Date, delta: _DateTimeDelta) -> Foundation.Date { return delta.after(date) }
public func + (delta: _DateTimeDelta, date: Foundation.Date) -> Foundation.Date { return delta.after(date) }
public func - (date: Foundation.Date, delta: _DateTimeDelta) -> Foundation.Date { return delta.before(date) }


// MARK: - Calendar

public extension Foundation.Date {

    public static var january: Foundation.Date { return Foundation.Date.today.withMonth(1).withDay(1) }
    public static var february: Foundation.Date { return Foundation.Date.today.withMonth(2).withDay(1) }
    public static var march: Foundation.Date { return Foundation.Date.today.withMonth(3).withDay(1) }
    public static var april: Foundation.Date { return Foundation.Date.today.withMonth(4).withDay(1) }
    public static var may: Foundation.Date { return Foundation.Date.today.withMonth(5).withDay(1) }
    public static var june: Foundation.Date { return Foundation.Date.today.withMonth(6).withDay(1) }
    public static var july: Foundation.Date { return Foundation.Date.today.withMonth(7).withDay(1) }
    public static var august: Foundation.Date { return Foundation.Date.today.withMonth(8).withDay(1) }
    public static var september: Foundation.Date { return Foundation.Date.today.withMonth(9).withDay(1) }
    public static var october: Foundation.Date { return Foundation.Date.today.withMonth(10).withDay(1) }
    public static var november: Foundation.Date { return Foundation.Date.today.withMonth(11).withDay(1) }
    public static var december: Foundation.Date { return Foundation.Date.today.withMonth(12).withDay(1) }

    public static var jan: Foundation.Date { return self.january }
    public static var feb: Foundation.Date { return self.february }
    public static var mar: Foundation.Date { return self.march }
    public static var apr: Foundation.Date { return self.april }
    public static var jun: Foundation.Date { return self.june }
    public static var jul: Foundation.Date { return self.july }
    public static var aug: Foundation.Date { return self.august }
    public static var sep: Foundation.Date { return self.september }
    public static var oct: Foundation.Date { return self.october }
    public static var nov: Foundation.Date { return self.november }
    public static var dec: Foundation.Date { return self.december }

    public var first: _CalendarDelta { return self.calendarDelta(0) }
    public var second: _CalendarDelta { return self.calendarDelta(1) }
    public var third: _CalendarDelta { return self.calendarDelta(2) }
    public var fourth: _CalendarDelta { return self.calendarDelta(3) }
    public var fifth: _CalendarDelta { return self.calendarDelta(4) }
    public var last: _CalendarDelta { return self.calendarDelta(-1) }

    fileprivate func calendarDelta(_ ordinal: Int) -> _CalendarDelta {
        return _CalendarDelta(date: self, ordinal: ordinal)
    }


    public static var sunday: Foundation.Date? { return Foundation.Date.today.withWeekday(1) }
    public static var monday: Foundation.Date? { return Foundation.Date.today.withWeekday(2) }
    public static var tuesday: Foundation.Date? { return Foundation.Date.today.withWeekday(3) }
    public static var wednesday: Foundation.Date? { return Foundation.Date.today.withWeekday(4) }
    public static var thursday: Foundation.Date? { return Foundation.Date.today.withWeekday(5) }
    public static var friday: Foundation.Date? { return Foundation.Date.today.withWeekday(6) }
    public static var saturday: Foundation.Date? { return Foundation.Date.today.withWeekday(7) }

}

public struct _CalendarDelta {

    public var date: Foundation.Date

    /// `0` for first and `-1` for last
    public var ordinal: Int

    public var sunday: Foundation.Date? { return self.weekday(1) }
    public var monday: Foundation.Date? { return self.weekday(2) }
    public var tuesday: Foundation.Date? { return self.weekday(3) }
    public var wednesday: Foundation.Date? { return self.weekday(4) }
    public var thursday: Foundation.Date? { return self.weekday(5) }
    public var friday: Foundation.Date? { return self.weekday(6) }
    public var saturday: Foundation.Date? { return self.weekday(7) }

    fileprivate func weekday(_ weekday: Int) -> Foundation.Date? {
        if self.ordinal == -1 {
            for i in (1...5).reversed() {
                if let date = _CalendarDelta(date: self.date, ordinal: i).weekday(weekday) {
                    return date
                }
            }
            return nil
        }
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components([.year, .month, .day, .weekday], from: self.date)
        let ordinal = (weekday >= components.weekday!) ? self.ordinal : self.ordinal + 1
        components.day = components.day! + weekday + 7 * ordinal - components.weekday!
        if let date = calendar.date(from: components), date.month == components.month {
            return date
        }
        return nil
    }

}
