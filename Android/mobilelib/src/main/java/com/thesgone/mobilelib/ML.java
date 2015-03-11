package com.thesgone.mobilelib;

import android.app.Activity;
import android.app.AlertDialog;

/**
 * Created by stefanogiovannitti on 05/11/14.
 */
public class ML {


    public static void ASSERT(final boolean condition, final String message) throws RuntimeException {
        if (!condition)
            throw new RuntimeException(message);
    }


    public static void failPopup(String message, String title, Activity activity)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);

        // 2. Chain together various setter methods to set the dialog characteristics
        builder.setMessage(message)
                .setTitle( title );

        // 3. Get the AlertDialog from create()
        AlertDialog dialog = builder.create();

        dialog.show();

    }//end display

}
