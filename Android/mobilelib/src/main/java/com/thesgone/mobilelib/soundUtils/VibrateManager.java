package com.thesgone.mobilelib.soundUtils;

import android.content.Context;
import android.os.Vibrator;

/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.

MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/


public class VibrateManager {

    Vibrator vibrator_;
    public VibrateManager(Context context){
        vibrator_ = (Vibrator)context.getSystemService(Context.VIBRATOR_SERVICE);
    }

    public void vibrate(long secs){
        vibrator_.vibrate(secs * 1000);
    }

    public void vibrate(){
        vibrate(1);
    }

    public void vibrate(final long[] secsPatterns){

        long[] milliSecs = secsPatterns;

        for(long mill : milliSecs){
            mill *= 1000;
        }

        vibrator_.vibrate(milliSecs, 0);
    }

    public void stop(){
        vibrator_.cancel();
    }

}
