package com.thesgone.mobilelib.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

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


public class DatabaseHelper extends SQLiteOpenHelper {

	private List<BaseTable> tables_;
    private DatabaseUpdater updater_;

    public interface DatabaseUpdater{
        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion);
    }

	DatabaseHelper(Context context,
                          String databaseName,
                          int databaseVersion,
                          List<BaseTable> tables,
                          DatabaseUpdater updater) {

        super(context, databaseName, null, databaseVersion);
        tables_ = tables;
        updater_ = updater;

    }

    BaseTable isTablePresent(String name, AtomicBoolean found){
        BaseTable table = null;
        found.set(false);
        for(BaseTable t : tables_ ){
            if(t.name().equals(name)){
                table = t;
                found.set(true);
                break;
            }
        }
        return table;
    }

    public List<BaseTable> getTables(){
        return tables_;
    }


    @Override
	public void onCreate(SQLiteDatabase db) {

        for(BaseTable t : tables_)
        {
            db.execSQL(t.onCreateCommand());
        }

	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

        updater_.onUpgrade(db, oldVersion, newVersion);

	}

}


