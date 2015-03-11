package com.thesgone.mobilelib.database;

/**
 * Created by stefanogiovannitti on 06/11/14.
 */
public abstract class DatabaseObject {

    public abstract String name();
    public int objectId(){
        return objId;
    }
    public static int objectIdIndex(){
        return 0;
    }

    public int objId = -1;


}
