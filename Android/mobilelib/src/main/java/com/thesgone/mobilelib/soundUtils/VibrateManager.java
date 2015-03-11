package com.thesgone.mobilelib.soundUtils;

import android.content.Context;
import android.os.Vibrator;

/**
 * Created by stefanogiovannitti on 26/12/14.
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
