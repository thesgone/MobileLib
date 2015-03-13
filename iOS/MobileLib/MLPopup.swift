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

public class MLPopup : NSObject{
    
    public class func display(title : MLString, message : MLString, view : UIViewController){
        
       display(title, message : message, view : view, okCompletion : nil)
    }
    
    public class func display(title : MLString, message : MLString, view : UIViewController, okCompletion : ((UIAlertAction!)->Void)?){
        
        var errorAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler : okCompletion))
        
        view.presentViewController(errorAlert, animated: false, completion: nil)
    }
    
}