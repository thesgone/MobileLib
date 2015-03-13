/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.
MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

import Foundation
import UIKit


extension MLDate{
    

    private func getDateComponents(toDate : MLDate, unit : NSCalendarUnit)->NSDateComponents{
        let cal = NSCalendar.currentCalendar()
        var component : NSDateComponents = cal.components(unit, fromDate: self, toDate: toDate, options: nil)
        
        return component
    }
    
    public func nbDaysBetweenDates( toDate : MLDate)->Int{
        
        var components : NSDateComponents = getDateComponents(toDate, unit : NSCalendarUnit.DayCalendarUnit)
        
        let nbDays : Int = components.day
        
        return nbDays

    }
    

    
    public func getWeekDay()->MLString{
 
        return getStringIimpl( "eeee")
   
    }
    
    public func getDate()->MLString{
        
        var dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        return dateFormatter.stringFromDate(self)

    }

    
    public func getTime()->MLString{
        
        var dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        return dateFormatter.stringFromDate(self)    }

    public func getString()->MLString{

        var dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle

        return dateFormatter.stringFromDate(self)
    }

    
    func getStringIimpl( config : MLString)->MLString{
        
        var locale : NSLocale = NSLocale.currentLocale()
        
        var dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(config, options: 0, locale: locale)
        
        var dateStr : MLString = dateFormatter.stringFromDate(self) as MLString
        
        return dateStr

    }

}