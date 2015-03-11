package com.thesgone.mobilelib.database;

import android.content.ContentValues;
import android.database.Cursor;

import java.util.ArrayList;
import java.util.List;

public abstract class BaseTable {


    public static final String TABLE_ID = "_id";

    protected BaseTableDelegate delegate_;

    private String createCommand_;

    private List<BaseTableDelegate.TableColumn> columnDefinitions_;

    public BaseTable(BaseTableDelegate delegate) {
        delegate_ = delegate;

        columnDefinitions_ = delegate_.columnDefinitions();

        BaseTableDelegate.TableColumn idDefinition = new BaseTableDelegate.TableColumn();
        idDefinition.columnName = TABLE_ID;
        idDefinition.columnType = DatabaseQuery.INTEGER_KEY_AUTOINCREMENT;

        columnDefinitions_.add(0, idDefinition);

        String colValues = "";

        int i = 0;
        int nbDefs = columnDefinitions_.size();
        for (BaseTableDelegate.TableColumn def : columnDefinitions_) {

            colValues += (def.columnName + DatabaseQuery.SPACE + def.columnType);
            if ((i + 1) < nbDefs)
                colValues += DatabaseQuery.COMMA;

            ++i;
        }


        createCommand_ = DatabaseQuery.createTable(delegate_.tableName(), colValues);

    }

    public List<DatabaseObject> getObjects(Cursor cursor){

        List<DatabaseObject> objs = new ArrayList<DatabaseObject>();

        cursor.moveToFirst();

        while (!cursor.isAfterLast()) {

            DatabaseObject obj = getObject(cursor);
            obj.objId = cursor.getInt(DatabaseObject.objectIdIndex());

            objs.add(obj);

            cursor.moveToNext();
        }

        cursor.close();

        return objs;
    }

    public abstract DatabaseObject getObject(Cursor cursor);
    public abstract ContentValues contentValues(DatabaseObject object);


    String onCreateCommand() {
        return createCommand_;
    }

    String onDeleteCommand() {
        String deleteCommand = DatabaseQuery.dropTableIfExists(delegate_.tableName());

        return deleteCommand;
    }

    public String name() {
        return delegate_.tableName();
    }



}