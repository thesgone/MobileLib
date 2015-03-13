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

public protocol ErrorDelegate{
   
    func showConnectionError(okCompletion : ((UIAlertAction!)->Void)?)
    func showPushPermissionError(okCompletion : ((UIAlertAction!)->Void)?)
}

public class MLPush {
    
    private let application : UIApplication
    
    private let errorDelegate : ErrorDelegate
    
    public init(application : UIApplication, errorDelegate : ErrorDelegate){
        self.application = application
        self.errorDelegate = errorDelegate
    }
    
    public func canSendPush()->Bool{
        
        var res = true
        if(self.application.currentUserNotificationSettings().types == UIUserNotificationType.None){
            res = false
        }
        
        return res

      
    }
    
    public class func userName()->MLString{
        return PFUser.currentUser().username
    }
    
    public class func userId()->MLString{
        return PFUser.currentUser().objectId
    }
    
    public func resetApplicationBadge(){
        
        self.application.applicationIconBadgeNumber = 0
        PFInstallation.currentInstallation().badge = 0
        self.saveObject(PFInstallation.currentInstallation(), saveCompletion: nil, onErrorCompletion: {(e : MLString)->Void in PFInstallation.currentInstallation().saveEventually({ (res : Bool, error : NSError!) -> Void in
        })}, saveEventually: false)
    }
    
    public func sendPushInBackGround(push : PFPush, successCompletion : (()->Void)?, onErrorCompletion : ((errorStr : MLString ) -> Void)?){
        
        if(self.canSendPush() == false){
            if(onErrorCompletion != nil){
                onErrorCompletion!(errorStr: "")
            }
            self.showPushPermissionError()
            return
        }
        
        
        if(MLReachability.isConnectedToNetwork() == false){
            if(onErrorCompletion != nil){
                onErrorCompletion!(errorStr: "")
            }
            self.showConnectionError()
            return
        }
        
        push.sendPushInBackgroundWithBlock{ (object : Bool, error : NSError!) -> Void in
            if(error == nil){
                TryCatch.try({ () -> Void in
                    
                    if (successCompletion != nil){
                        successCompletion!()
                    }
                    
                    },catch: { (exception) -> Void in
                        if(onErrorCompletion != nil){
                            onErrorCompletion!(errorStr: exception.reason!)
                        }else{
                            println(exception.reason!)
                        }
                    }){ () -> Void in
                }
                
            }else{
                if(onErrorCompletion != nil){
                    onErrorCompletion!(errorStr: error.description)
                }else{
                    println(error.description)
                }
            }
        }
    }
    
    
    public func saveObject(obj : PFObject, saveCompletion : (()->Void)?, onErrorCompletion : ((errorStr : MLString ) -> Void)?, saveEventually : Bool){
        
        if(MLReachability.isConnectedToNetwork() == false){
            if(onErrorCompletion != nil){
                onErrorCompletion!(errorStr: "")
            }
            self.showConnectionError()
            
            if(!saveEventually){
                return
            }
        }
        
        var completion = { (success: Bool!, error: NSError!)->Void in
            if(error == nil){
                
                TryCatch.try({ () -> Void in
                    if(saveCompletion != nil){
                        saveCompletion!()
                    }
                    },catch: { (exception) -> Void in
                        if(onErrorCompletion != nil){
                            onErrorCompletion!(errorStr: exception.reason!)
                        }else{
                            println(exception.reason!)
                        }
                    }){ () -> Void in
                }
                
                
            }else{
                if(onErrorCompletion != nil){
                    onErrorCompletion!(errorStr: error.description)
                }else{
                    println(error.description)
                }
            }
            
        }
        
        if(saveEventually){
            obj.saveEventually(completion)
        }else{
            obj.saveInBackgroundWithBlock(completion)
        }
        
    }
    
    public func findObjects(className : MLString, key : MLString, equalTo value : MLString, completion : (objs : [AnyObject]! ) -> Void){
        
        findObjects(className, key : key, equalTo : value, completion : completion, nil)
    }
    public func findObjects(className : MLString, key : MLString, equalTo value : MLString, completion : (objs : [AnyObject]! ) -> Void, onErrorCompletion : ((errorStr : MLString ) -> Void)? ){
        
        let query = PFQuery(className: className)
        query.whereKey(key, equalTo: value)
        findQuery(query, completion: completion, onErrorCompletion: onErrorCompletion)
    }
    
    public func findObjects(className : MLString, key : MLString!, containedIn value : [AnyObject]!, completion : (objs : [AnyObject]! ) -> Void){
        
        findObjects(className, key : key, containedIn : value, completion : completion, nil)
    }
    public func findObjects(className : MLString, key : MLString!, containedIn value : [AnyObject]!, completion : (objs : [AnyObject]! ) -> Void, onErrorCompletion : ((errorStr : MLString ) -> Void)? ){
        
        let query = PFQuery(className: className)
        query.whereKey(key, containedIn: value)
        findQuery(query, completion: completion, onErrorCompletion: onErrorCompletion)
    }
    
    public func fetchObjPointer(object : PFObject, tag : MLString, completion : (PFObject)->Void,
        onErrorCompletion : ((errorStr : MLString)->Void)?){
            
            if(MLReachability.isConnectedToNetwork() == false){
                if(onErrorCompletion != nil){
                    onErrorCompletion!(errorStr: "")
                }
                self.showConnectionError()
                return
            }
            
            object.fetchIfNeededInBackgroundWithBlock({ (object : PFObject!,error : NSError!) -> Void in
                
                if(error == nil){
                    
                    TryCatch.try({ () -> Void in
                        
                        var o = object[tag] as PFObject
                        completion(o)
                        
                        },catch: { (exception) -> Void in
                            if(onErrorCompletion != nil){
                                onErrorCompletion!(errorStr: exception.reason!)
                            }else{
                                println(exception.reason!)
                            }
                        }){ () -> Void in
                    }
                    
                }else{
                    if(onErrorCompletion != nil){
                        onErrorCompletion!(errorStr: error.description)
                    }else{
                        println(error.description)
                    }
                }
                
            })
            
    }
    
    public func deleteInBackground(object : PFObject, completion : ()->Void, onErrorCompletion : ((errorStr : MLString)->Void)? ){
        
        if(MLReachability.isConnectedToNetwork() == false){
            if(onErrorCompletion != nil){
                onErrorCompletion!(errorStr: "")
            }
            self.showConnectionError()
            return
        }
        
        object.deleteInBackgroundWithBlock({ (res : Bool,error : NSError!) -> Void in
            
            if(error == nil){
                
                TryCatch.try({ () -> Void in
                    
                    completion()
                    
                    },catch: { (exception) -> Void in
                        if(onErrorCompletion != nil){
                            onErrorCompletion!(errorStr: exception.reason!)
                        }else{
                            println(exception.reason!)
                        }
                    }){ () -> Void in
                }
                
            }else{
                if(onErrorCompletion != nil){
                    onErrorCompletion!(errorStr: error.description)
                }else{
                    println(error.description)
                }
            }
            
        })
        
    }
    
    public func findQuery(query : PFQuery, completion : (objs : [AnyObject]! ) -> Void){
        findQuery(query, completion : completion, onErrorCompletion : nil)
    }
    
    public func findQuery(query : PFQuery, completion : (objs : [AnyObject]! ) -> Void, onErrorCompletion : ((errorStr : MLString ) -> Void)? ){
        
        if(MLReachability.isConnectedToNetwork() == false){
            if(onErrorCompletion != nil){
                onErrorCompletion!(errorStr: "")
            }
            self.showConnectionError()
            return
        }
        
        query.findObjectsInBackgroundWithBlock({ (objs : [AnyObject]!, error : NSError!) -> Void in
            if(error == nil){
                
                TryCatch.try({ () -> Void in
                    
                    completion(objs: objs)
                    
                    
                    },catch: { (exception) -> Void in
                        if(onErrorCompletion != nil){
                            onErrorCompletion!(errorStr: exception.reason!)
                        }else{
                            println(exception.reason!)
                        }
                    }){ () -> Void in
                }
                
            }else{
                if(onErrorCompletion != nil){
                    onErrorCompletion!(errorStr: error.description)
                }else{
                    println(error.description)
                }
            }
        })
    }
    
    func showConnectionError(){
        self.errorDelegate.showConnectionError(nil)
    }
    func showConnectionError(okCompletion : ((UIAlertAction!)->Void)?){
        self.errorDelegate.showConnectionError(okCompletion)

    }
    func showPushPermissionError(){
        self.errorDelegate.showPushPermissionError(nil)
    }
    func showPushPermissionError(okCompletion : ((UIAlertAction!)->Void)?){
        self.errorDelegate.showPushPermissionError(okCompletion)
    }
    
}

