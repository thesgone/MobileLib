package com.thesgone.mobilelib.soundUtils;

import android.content.Context;
import android.media.MediaPlayer;
import android.net.Uri;

/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.

MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/


public class SoundManager {

    MediaPlayer mp_;

    public void play(Context context, Uri uri){
        mp_=MediaPlayer.create(context, uri);
        mp_.start();
    }

    public void stop(){
        if(mp_ != null){
            mp_.stop();
        }
    }

    public void pause(){
        if(mp_ != null){
            mp_.pause();
        }
    }


}
