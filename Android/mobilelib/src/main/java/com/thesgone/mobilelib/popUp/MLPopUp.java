package com.thesgone.mobilelib.popUp;

import android.app.AlertDialog;
import android.content.Context;
import android.util.Log;

/**
 * Created by stefanogiovannitti on 11/11/14.
 */
public class MLPopUp {

    static final String TAG = "MLPopUp";

    public static void display(String title, String message, Context context)
    {
        try {
            AlertDialog.Builder builder = new AlertDialog.Builder(context);

            // 2. Chain together various setter methods to set the dialog characteristics
            builder.setMessage(message)
                    .setTitle(title);

            // 3. Get the AlertDialog from create()
            AlertDialog dialog = builder.create();

            dialog.show();
        }catch (Exception e){
            Log.d(TAG, "Exception: " + e.getMessage());
        }

    }//end display


}
