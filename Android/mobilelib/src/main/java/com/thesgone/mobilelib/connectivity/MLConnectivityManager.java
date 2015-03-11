package com.thesgone.mobilelib.connectivity;

import android.content.Context;
import android.net.NetworkInfo;
import android.net.ConnectivityManager;

/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.

MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/


public class MLConnectivityManager {



   public enum ConnectionStatus {
        wifi,
        mobile,
        none
    }

    public static ConnectionStatus getConnectivityStatus(Context context) {
        ConnectivityManager cm = (ConnectivityManager) context
                .getSystemService(Context.CONNECTIVITY_SERVICE);

        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
        if (null != activeNetwork) {
            if(activeNetwork.getType() == ConnectivityManager.TYPE_WIFI)
                return ConnectionStatus.wifi;

            if(activeNetwork.getType() == ConnectivityManager.TYPE_MOBILE)
                return ConnectionStatus.mobile;
        }
        return ConnectionStatus.none;
    }

    public static boolean isConnectionActive(Context context) {
        ConnectionStatus conn = MLConnectivityManager.getConnectivityStatus(context);

        if(conn == ConnectionStatus.none)
            return false;

        return true;
    }
}
