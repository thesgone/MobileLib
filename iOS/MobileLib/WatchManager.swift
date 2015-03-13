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
import WatchKit

public protocol WatchRequestType{
    
    func type()->MLString

}

public class InvalidWatchRequest : WatchRequestType{
    
    public func type()->MLString{
        return "Invalid"
    }
}

public class WatchManager {
    
    public var requestGenerator : RequestGenerator
    
    public class func typeName() -> MLString{
        return "Type"
    }
    
    public init(generator : RequestGenerator){
        self.requestGenerator = generator        
    }
   

    public func sendRequest(request : WatchRequest, completion : (WatchResult)->Void){
    
        var data = self.requestGenerator.createDataFromRequest(request)
        data[WatchManager.typeName()] = NSKeyedArchiver.archivedDataWithRootObject(request.type.type())
        
        WKInterfaceController.openParentApplication(data,
            reply: {(reply, error) -> Void in
                
                TryCatch.try({ () -> Void in
                    
                    switch (reply as? WatchData, error) {
                    case let (data, nil) where data != nil:
                        let result = self.requestGenerator.createResultsFromData(data!)
                        completion(result)
                    case let (_, .Some(error)):
                        println("got an error: \(error)") // take corrective action here
                    default:
                        println("no error but didn't get data either...") // unexpected situation
                    }
                    
                    },catch: { (exception) -> Void in
                        println(exception.reason!)
                    }){ () -> Void in }
                
        })
    }
    
    public func getRequest(userInfo: [NSObject : AnyObject]!,
        reply: (([NSObject : AnyObject]!) -> Void)!){
        
        let data = userInfo as? WatchData
        
        let request = requestGenerator.createRequestFromData(data!)
        
        let result = requestGenerator.processRequest(request)
      
        let dataRes = requestGenerator.createDataFromResults(result)
       
        reply(dataRes)
    }
  
}