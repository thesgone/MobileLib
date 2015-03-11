package com.thesgone.mobilelib.soundUtils;

import android.content.Context;
import android.media.MediaPlayer;
import android.net.Uri;

/**
 * Created by stefanogiovannitti on 26/12/14.
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
