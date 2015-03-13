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

public class BaseDataResult : NSObject, NSCoding{
    
    public override init(){}
    
    required public init(coder aDecoder: NSCoder) {
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
    }

}

public class TableWatchResult : WatchResult{
    
    public typealias list_type = [BaseDataResult]
    
    public var data = list_type()
    
    public init(type: WatchRequestType, data : list_type){
        super.init(type: type)
        self.data = data
    }
    
}


