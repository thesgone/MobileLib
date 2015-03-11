package com.thesgone.mobilelib.database;

import java.util.List;

/**
 * Created by stefanogiovannitti on 05/11/14.
 */
public interface BaseTableDelegate {

    public class TableColumn{
        public String columnName;
        public String columnType;
    }
    public String tableName();
    public List<TableColumn> columnDefinitions();
}
