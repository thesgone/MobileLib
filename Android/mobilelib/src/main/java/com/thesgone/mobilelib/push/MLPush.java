package com.thesgone.mobilelib.push;

import android.content.Context;

import com.parse.DeleteCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParsePush;
import com.parse.ParseQuery;
import com.parse.ParseUser;
import com.parse.SaveCallback;
import com.parse.SendCallback;
import com.thesgone.mobilelib.connectivity.MLConnectivityManager;
import com.thesgone.mobilelib.interfece.MLCompletion;

import java.util.List;

/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.

MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/


public class MLPush {

    public interface ErrorDelegate{
        void showError(String error);
        void showConnectionError();
    }

    private Context context_;
    private ErrorDelegate delegate_;

    public Context getContext(){
        return context_;
    }

    public MLPush(Context context, ErrorDelegate delegate){
        context_ = context;
        delegate_ = delegate;

    }

    public static String userName(){
        return ParseUser.getCurrentUser().getUsername();
    }

    public static String userId() {
        return ParseUser.getCurrentUser().getObjectId();
    }


    public void sendPushInBackGround(ParsePush push, final MLCompletion successCompletion, final MLCompletion onErrorCompletion) {

        if (!MLConnectivityManager.isConnectionActive(context_)) {
            if (onErrorCompletion != null)
                onErrorCompletion.performCompletion();
            showConnectionError();
            return;
        }
        push.sendInBackground(new SendCallback() {
            @Override
            public void done(ParseException e) {
                if (e == null) {
                    try {
                        if (successCompletion != null)
                            successCompletion.performCompletion();
                    } catch (Exception er) {
                        if (onErrorCompletion != null)
                            onErrorCompletion.performCompletion();
                        showError(e.getMessage());
                    }
                } else {
                    if (onErrorCompletion != null)
                        onErrorCompletion.performCompletion();
                }
            }
        });
    }

    public void findObjectsEqualTo(String objectName,
                                   String key,
                                   Object value,
                                   SafeFindCallBack<ParseObject> callback)
    {
        findObjectsEqualTo(objectName,
                key,
                value,
                callback,
                null);
    }

    public void findObjectsEqualTo(String objectName,
                                   String key,
                                   Object value,
                                   SafeFindCallBack<ParseObject> callback,
                                   MLCompletion errorCompletion){

        try {
            ParseQuery<ParseObject> query = new ParseQuery<ParseObject>(objectName);
            query.whereEqualTo(key, value);

            findQuery(query, callback, errorCompletion);
        }catch(Exception e){
            showError(e.getMessage());
        }

    }

    public void findObjectsContainedIn(String objectName,
                                       String key,
                                       List< ? extends Object > value,
                                       SafeFindCallBack<ParseObject> callback)
    {
        findObjectsContainedIn(objectName,
                key,
                value,
                callback,
                null);
    }
    public void findObjectsContainedIn(String objectName,
                                       String key,
                                       List< ? extends Object > value,
                                       SafeFindCallBack<ParseObject> callback,
                                       MLCompletion errorCompletion){

        try {
            ParseQuery<ParseObject> query = new ParseQuery<ParseObject>(objectName);
            query.whereContainedIn(key, value);

            findQuery(query, callback, errorCompletion);
        }catch(Exception e){
            showError(e.getMessage());
        }

    }

    public void deleteInBackGround(ParseObject object, final MLCompletion deleteCompletion, final MLCompletion errorCompletion){

        if (!MLConnectivityManager.isConnectionActive(context_)) {
            if(errorCompletion != null)
                errorCompletion.performCompletion();
            showConnectionError();
            return;
        }


        object.deleteInBackground(new DeleteCallback() {
            @Override
            public void done(ParseException e) {
                if (e == null) {
                    try {
                        deleteCompletion.performCompletion();
                    } catch (Exception e1) {
                        showError(e1.getMessage());
                    }
                } else {
                    if (errorCompletion != null)
                        errorCompletion.performCompletion();
                    showError(e.getMessage());
                }

            }
        });

    }

    public void saveObject(ParseObject obj, final MLCompletion saveCompletion, final MLCompletion errorCompletion, boolean saveEventually){

        if(!MLConnectivityManager.isConnectionActive(context_)){
            if(errorCompletion != null){
                errorCompletion.performCompletion();
            }
            showConnectionError();

            if(!saveEventually)
                return;
        }

        SaveCallback scb = new SaveCallback() {
            @Override
            public void done(ParseException e) {
                if (e == null) {
                    try {
                        if (saveCompletion != null)
                            saveCompletion.performCompletion();
                    } catch (Exception er) {
                        if (errorCompletion != null) {
                            errorCompletion.performCompletion();
                        }
                        showError(e.getMessage());
                    }
                } else {
                    if (errorCompletion != null) {
                        errorCompletion.performCompletion();
                    }
                }

            }
        };

        if(saveEventually)
            obj.saveEventually(scb);
        else
            obj.saveInBackground(scb);
    }

    public  < T extends ParseObject > void  findQuery(ParseQuery< T > query,
                                                      SafeFindCallBack< T > callback){
        findQuery( query, callback, null);
    }

    public  < T extends ParseObject > void  findQuery(ParseQuery< T > query,
                                                      SafeFindCallBack< T > callback,
                                                      MLCompletion errorCompletion){
        if (!MLConnectivityManager.isConnectionActive(context_)) {

            if(errorCompletion != null)
                errorCompletion.performCompletion();

            showConnectionError();

        } else {

            callback.setErrorCompletion(errorCompletion);
            query.findInBackground(callback);
        }
    }


    private void showConnectionError(){
        delegate_.showConnectionError();
    }

    private void showError(String error){
        delegate_.showError(error);
    }


}

