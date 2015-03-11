package com.thesgone.mobilelib.database;

/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.

MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
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
