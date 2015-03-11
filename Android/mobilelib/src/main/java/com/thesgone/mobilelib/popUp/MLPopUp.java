package com.thesgone.mobilelib.popUp;

import android.app.AlertDialog;
import android.content.Context;
import android.util.Log;

/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.

MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
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
