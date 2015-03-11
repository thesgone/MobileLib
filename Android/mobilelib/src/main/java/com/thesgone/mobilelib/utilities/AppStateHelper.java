package com.thesgone.mobilelib.utilities;

import android.app.ActivityManager;
import android.content.Context;

import java.util.List;

/**
 * Created by stefanogiovannitti on 22/12/14.
 */
public class AppStateHelper {

    static public boolean isAppInForeground(Context context){
        List<ActivityManager.RunningTaskInfo> tasks =
                ((ActivityManager) context.getSystemService(
                        Context.ACTIVITY_SERVICE))
                        .getRunningTasks(1);
        if (tasks.isEmpty()) {
            return false;
        }
        return tasks
                .get(0)
                .topActivity
                .getPackageName()
                .equalsIgnoreCase(context.getPackageName());
    }
}
