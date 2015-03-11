package com.thesgone.mobilelib.dateUtils;

import android.content.Context;
import android.text.format.DateUtils;

import com.thesgone.mobilelib.ML;

import java.text.DateFormatSymbols;
import java.util.Calendar;
import java.util.Date;

/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.

MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/


public class DateHelper {

    public Date currentDate(){
        Date currentDate = Calendar.getInstance().getTime();
        return currentDate;
    }

    public String getWeekDay(Date d){
        Calendar cal = getCalendar(d);

        int dayOfWeekInt =  cal.get(Calendar.DAY_OF_WEEK);

        DateFormatSymbols symbols = new DateFormatSymbols();

        String[] dayNames = symbols.getWeekdays();
        ML.ASSERT(dayOfWeekInt<dayNames.length, "expected dayOfWeekInt<dayNames.length");

        return dayNames[dayOfWeekInt];
    }

    public String getDateOnly(Date d, Context context){

        Calendar cal = getCalendar(d);

        String res = DateUtils.formatDateTime(context,
                cal.getTimeInMillis(),
                DateUtils.FORMAT_SHOW_DATE | DateUtils.FORMAT_NUMERIC_DATE | DateUtils.FORMAT_SHOW_YEAR);

        return res;

    }

    public String getHour(Date d, Context context){

        Calendar cal =getCalendar(d);

        String res = DateUtils.formatDateTime(context,
                cal.getTimeInMillis(),
                DateUtils.FORMAT_NUMERIC_DATE | DateUtils.FORMAT_SHOW_TIME);//DateUtils.FORMAT_SHOW_DATE |

        return res;

    }

    public String getDateTime(Date d, Context context){
        Calendar cal =getCalendar(d);

        String res = DateUtils.formatDateTime(context,
                cal.getTimeInMillis(),
                DateUtils.FORMAT_SHOW_DATE | DateUtils.FORMAT_NUMERIC_DATE | DateUtils.FORMAT_SHOW_TIME);
        return res;

    }

    public long nbDaysBetweenDates(Date startDate, Date endDate) {

        Calendar sDate = getDatePart(startDate);
        Calendar eDate = getDatePart(endDate);

        int sign = 1;

        if(sDate.after(endDate)){
            Calendar tmp = sDate;
            sDate = eDate;
            eDate = tmp;

            sign = -1;
        }

        long daysBetween = 0;
        while (sDate.before(eDate)) {
            sDate.add(Calendar.DAY_OF_MONTH, 1);
            daysBetween++;
        }
        return (sign*daysBetween);
    }

    public boolean isToday(Date d){
        Calendar cal = getCalendar(d);
        return DateUtils.isToday(cal.getTimeInMillis());
    }

    private Calendar getCalendar(Date d){
        Calendar cal = Calendar.getInstance();
        cal.setTime(d);
        return cal;
    }

    private Calendar getDatePart(Date d){

        Calendar cal = getCalendar(d);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);

        return cal;
    }
}
