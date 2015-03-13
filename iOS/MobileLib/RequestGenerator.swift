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

public class WatchRequest : NSObject{
    
    public var type : WatchRequestType
    
    public override init(){self.type = InvalidWatchRequest()}
    
    public init(type : WatchRequestType){
        self.type = type
    }
}

public class WatchResult{
    
    public var type : WatchRequestType
    
    public init(type : WatchRequestType){
        self.type = type
    }
}

public typealias WatchData = [MLString : NSData]

public protocol RequestGenerator{
    
    func createDataFromRequest(request : WatchRequest)->WatchData
    
    func createRequestFromData(data : WatchData)->WatchRequest
    
    func createResultsFromData(data : WatchData)->WatchResult
    
    func createDataFromResults(results : WatchResult)->WatchData
    
    func processRequest(request : WatchRequest)->WatchResult
    
}

public class NullRequestGenerator : RequestGenerator {
    
    public init(){}
    
    public func createDataFromRequest(request : WatchRequest)->WatchData{
        return WatchData()
    }
    
    public func createRequestFromData(data : WatchData)->WatchRequest{
        return WatchRequest(type: InvalidWatchRequest())
    }
    
    public func createResultsFromData(data : WatchData)->WatchResult{
        return WatchResult(type: InvalidWatchRequest())
    }
    
    public func createDataFromResults(results : WatchResult)->WatchData{
        return WatchData()
    }
    
    public func processRequest(request : WatchRequest)->WatchResult{
        return WatchResult(type: InvalidWatchRequest())
    }

}
