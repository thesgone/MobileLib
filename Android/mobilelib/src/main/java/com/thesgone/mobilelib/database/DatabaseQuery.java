package com.thesgone.mobilelib.database;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.

MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/


public class DatabaseQuery {

	public static final String SPACE = " ";

	public static final String COMMA = ", ";

	private static final String CREATE_COMMAND = "create table";

	private static final String DELETE_COMMAND = "DROP TABLE IF EXISTS";

    private static final String ALTER_TABLE_COMMAND = "ALTER TABLE";

    private static final String ADD_COLUMN_COMMAND = "ADD COLUMN";

    public static final String TEXT = "text";

	public static final String TEXT_NOT_NULL = "text not null";

	public static final String INTEGER = "integer";

	public static final String LONG = "long";

	public static final String INTEGER_KEY_AUTOINCREMENT = "integer primary key autoincrement";

	public static final String REAL = "real";

    public static final String DATA = "blob";

    public static final String DESCENDING_ORDER = "DESC";

    public static final String ASCENDING_ORDER = "ASC";


    public static String createTable(String tableName, String colValues){

		String result = CREATE_COMMAND+SPACE+"'"+tableName+"'"+SPACE+"("+ colValues +");";

		return result;

	}

    public static String addColumnInTable(String tableName, String colName, String colType, String defaultValue){

        String result = ALTER_TABLE_COMMAND + SPACE + tableName +
                SPACE + ADD_COLUMN_COMMAND + SPACE + colName +
                SPACE + colType + SPACE + "DEFAULT" + SPACE + defaultValue + ";";

        return result;

    }
	
	public static String dropTableIfExists(String tableName){

		String result = DELETE_COMMAND+" '"+tableName+"'";

		return result;

	}

	public static String maxValueOfColumnQuery(String columnName)
	{
		String result = "MAX("+columnName+")";

		return result;
	}
	
	public static boolean isTableInDB(String tableName, SQLiteDatabase database){
		boolean tableInDB = false;
		Cursor tableQueryCursor = database.rawQuery("select DISTINCT tbl_name from sqlite_master where tbl_name = '"+tableName+"'", null);
		if(tableQueryCursor!=null) {
			if(tableQueryCursor.getCount()>0) {

				tableInDB = true;
			}
			tableQueryCursor.close();
		}
		
		return tableInDB;
	}

}
