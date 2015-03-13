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

public class PhoneCaller: NSObject {
   
    public class func call(phoneNumber : MLString) -> NSURL?{
        var abh = AddressBookHelper()
        var trimmedPhone = abh.cleanPhoneNumber(phoneNumber)
        var phone = "tel://"+trimmedPhone
        let url = NSURL(string: phone)
        return url
    }
}
