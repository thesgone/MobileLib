package com.thesgone.mobilelib.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.thesgone.mobilelib.ML;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.

MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/


public class MLDatabase {


    public enum Order{
        none,
        ascending,
        descending
    }

    public MLDatabase(Context context,
                      String databaseName,
                      int databaseVersion,
                      List<BaseTable> tables,
                      DatabaseHelper.DatabaseUpdater updater)
    {

        DatabaseManager.initializeInstance(context, databaseName, databaseVersion, tables, updater);
    }

    public List<BaseTable> getTables(){
        DatabaseManager dbm = DatabaseManager.getInstance();
        return dbm.getTables();
    }

    public DatabaseObject fetchObjectById(String objectName, long objectId){
        String objId = Long.toString(objectId);
        List<DatabaseObject> objs = fetchObjectsEqualTo(objectName, BaseTable.TABLE_ID, objId);
        ML.ASSERT(objs.size() == 1, "expected only one objcet in table "+objectName+", with id "+objId);
        return  objs.get(0);
    }

    public List< DatabaseObject> fetchObjectsEqualTo(String objectName, String key, String value){
        return fetchObjects(objectName, key, value, null, Order.none);
    }

    public <T> List< DatabaseObject> fetchObjectsEqualTo(String objectName, String key, List<T> values){
        List<DatabaseObject> res = new ArrayList<DatabaseObject>();
        for(T val : values) {
            List<DatabaseObject> partialRes = fetchObjects(objectName, key, val.toString(), null, Order.none);
            res.addAll(partialRes);
        }
        return res;
    }

    public List< DatabaseObject> fetchObjectsEqualTo(String objectName,
                                              String key,
                                              String value,
                                              String orderKey,
                                              Order order){

        return fetchObjects(objectName, key, value, orderKey, order);
    }

    public List< DatabaseObject> fetchObjects(String objectName){
        return fetchObjects(objectName, null, null, null, Order.none);
    }

    public List< DatabaseObject> fetchObjects(String objectName, String orderKey, Order order){
        return fetchObjects(objectName, null, null, orderKey, order);
    }

    public List< DatabaseObject> fetchObjects(String objectName,
                                              String key,
                                              String value,
                                              String orderKey,
                                              Order order) {


        DatabaseManager dbm = DatabaseManager.getInstance();
        AtomicBoolean found = new AtomicBoolean();
        BaseTable table = dbm.isTablePresent(objectName, found);
        ML.ASSERT(found.get(), "MLDatabase.fetchObjects: table not present");

        SQLiteDatabase db = dbm.openDatabase();

        String comparatorStr = null;
        if (key != null && value != null)
            comparatorStr = key + " = '" + value + "'";

        String orderStr = null;
        if (orderKey != null) {

            switch (order) {
                case ascending:
                    orderStr = orderKey+" "+DatabaseQuery.ASCENDING_ORDER;
                    break;
                case descending:
                    orderStr = orderKey+" "+DatabaseQuery.DESCENDING_ORDER;
                    break;

            }

        }


        Cursor cursor = db.query(objectName, null, comparatorStr, null, null, null, orderStr);

        List< DatabaseObject> res = table.getObjects(cursor);

        dbm.closeDatabase();

        return res;
    }



    public void deleteObject(DatabaseObject o){
        DatabaseManager dbm = DatabaseManager.getInstance();
        AtomicBoolean found = new AtomicBoolean();
        BaseTable table = dbm.isTablePresent(o.name(), found);
        ML.ASSERT(found.get(), "MLDatabase.deleteObject: table not present");

        SQLiteDatabase db = dbm.openDatabase();
        db.delete(o.name(), BaseTable.TABLE_ID + " = '" + o.objectId() +"'", null);
        dbm.closeDatabase();

    }

    public void deleteAllObjects(String objectName){

        DatabaseManager dbm = DatabaseManager.getInstance();
        AtomicBoolean found = new AtomicBoolean();
        BaseTable table = dbm.isTablePresent(objectName, found);
        ML.ASSERT(found.get(), "MLDatabase.deleteAllObjects: table not found "+objectName);

        SQLiteDatabase db = dbm.openDatabase();
        db.execSQL(table.onDeleteCommand());
        db.execSQL(table.onCreateCommand());
        dbm.closeDatabase();
    }


    public long saveObject(DatabaseObject object) {

        DatabaseManager dbm = DatabaseManager.getInstance();
        AtomicBoolean found = new AtomicBoolean();
        BaseTable table = dbm.isTablePresent(object.name(), found);
        ML.ASSERT(found.get(), "MLDatabase.fetchObjects: table not present");
        ContentValues values = table.contentValues(object);

        SQLiteDatabase db = dbm.openDatabase();

        long insId = 0;
        if (object.objectId() != -1) {
            insId = db.update(table.name(), values, BaseTable.TABLE_ID + " = '" + object.objectId() + "'", null);
        } else {
            insId = db.insert(table.name(), null, values);
        }

        dbm.closeDatabase();

        ML.ASSERT(insId != -1, "failed to insert object");

        return insId;

    }

}
