/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.
MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

import Foundation


public class ML{
    
    public class func fail( message : MLString = "", file : MLString = __FILE__, line : Int = __LINE__){
        ML.assert(false, message: message, file : file, line : line)
    }
    public class func assert(predicate : @autoclosure ()-> Bool, message : MLString = "", file : MLString = __FILE__, line : Int = __LINE__){
        
        #if DEBUG
        if !predicate() {
            let failure = "\(file):\(line): "+message
            NSException(name: "assertion failed", reason: failure, userInfo: nil).raise()
            }
        #endif
    }
    
    public class func requirePopUp(condition : Bool, title : MLString, body : MLString, view : UIViewController, complition : ((UIAlertAction!) -> Void)?){
        
        if(condition){
            return;
        }
        
        failPopUp(title, body: body, view: view, complition)
    }
    
    public class func failPopUp(title : MLString, body : MLString, view : UIViewController, complition : ((UIAlertAction!) -> Void)?){
        
        
        var alert : UIAlertController = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler : complition))
        
        view.presentViewController(alert, animated: true, completion: nil)
    }

}