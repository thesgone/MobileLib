package com.thesgone.mobilelib;

import android.app.Activity;
import android.app.AlertDialog;

/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.

MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/


public class ML {


    public static void ASSERT(final boolean condition, final String message) throws RuntimeException {
        if (!condition)
            throw new RuntimeException(message);
    }


    public static void failPopup(String message, String title, Activity activity)
    {
        //
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);

        // 2. Chain together various setter methods to set the dialog characteristics
        builder.setMessage(message)
                .setTitle( title );

        // 3. Get the AlertDialog from create()
        AlertDialog dialog = builder.create();

        dialog.show();

    }//end display

}
