package com.thesgone.mobilelib.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

class DatabaseManager {

    private int openCounter_;

    private static DatabaseManager instance_;
    private static DatabaseHelper databaseHelper_;
    private SQLiteDatabase database_;

    static synchronized void initializeInstance(Context context,
                                                String databaseName,
                                                int databaseVersion,
                                                List<BaseTable> tables,
                                                DatabaseHelper.DatabaseUpdater updater) {
        if (instance_ == null) {
            instance_ = new DatabaseManager();
            databaseHelper_ = new DatabaseHelper(context, databaseName, databaseVersion, tables, updater);

        }
    }

    static synchronized DatabaseManager getInstance() {
        if (instance_ == null) {
            throw new IllegalStateException(DatabaseManager.class.getSimpleName() +
                    " is not initialized, call initializeInstance(..) method first.");
        }

        return instance_;
    }

    synchronized SQLiteDatabase openDatabase() {
        openCounter_++;
        if(openCounter_ == 1) {
            // Opening new database
            database_ = databaseHelper_.getWritableDatabase();
        }
        return database_;
    }

    synchronized void closeDatabase() {
        openCounter_--;
        if(openCounter_ == 0) {
            // Closing database
            database_.close();

        }
    }

    BaseTable isTablePresent(String name, AtomicBoolean found){
        return databaseHelper_.isTablePresent(name, found);
    }

    public List<BaseTable> getTables(){
        return databaseHelper_.getTables();
    }

}