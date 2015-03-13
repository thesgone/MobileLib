/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.
MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

import UIKit
import AddressBook

public class PhoneType{
    
    public var systemPhone : MLString = MLString()
    public var mlPhone : MLString = MLString()
}

public class AddressBookContact : NSObject
{
    public var compositeName : MLString?
    public var name : MLString?
    public var surname : MLString?

    public var contactId : ABRecordID?
    
    public typealias PhoneList = [MLString : PhoneType]
    public var phones : PhoneList?
}
