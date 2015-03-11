package com.thesgone.mobilelib.connectivity;

import android.content.Context;
import android.net.NetworkInfo;
import android.net.ConnectivityManager;

/**
 * Created by stefanogiovannitti on 18/12/14.
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
