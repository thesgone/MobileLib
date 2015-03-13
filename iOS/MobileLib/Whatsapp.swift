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

public class WhatsappHelper {
    
    var application : UIApplication
    
    let whatsapp = "whatsapp://"
    
    public init(application : UIApplication){
        self.application = application
    }
    
    public func canUseWhatsapp()->Bool{
        let url = NSURL(string : whatsapp + "app")
        let res = self.application.canOpenURL(url!)
        return res
    }
    
    public func getURL(addressBookId : MLString?, message : MLString?)->NSURL?{
        
        var command = whatsapp + "send"
        
        if(addressBookId != nil){
            command += "?abid=" + addressBookId!
        }
        
        if(message != nil){
            command += "?text=" + message!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

        }

  

        let url = NSURL(string : command)
        
        return url
        
    }
}