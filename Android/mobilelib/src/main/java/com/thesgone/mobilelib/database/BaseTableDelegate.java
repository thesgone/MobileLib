package com.thesgone.mobilelib.database;

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


public interface BaseTableDelegate {

    public class TableColumn{
        public String columnName;
        public String columnType;
    }
    public String tableName();
    public List<TableColumn> columnDefinitions();
}
