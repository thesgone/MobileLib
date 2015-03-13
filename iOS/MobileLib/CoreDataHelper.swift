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
import CoreData

public class CoreDataHelper : NSObject {
    
    // Mark: - Class variables
    
    private var managedObjectContext_ : NSManagedObjectContext = NSManagedObjectContext()
    
    // Mark: - Functions
    
    public override init(){
        
        super.init()
        
        var error:NSError? = nil
        
        NSFileManager.defaultManager().createDirectoryAtPath(directoryForDatabaseFilename(), withIntermediateDirectories: true, attributes: nil, error: &error)
        
        let path:MLString = "\(directoryForDatabaseFilename()) + \(databaseFilename())"
        
        let url:NSURL = NSURL(fileURLWithPath: path)!
        
        let managedModel:NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)!
        
        var storeCoordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true]
        
        if storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options, error:&error ) == nil{
            
            if(error != nil){
                println(error!.localizedDescription)
            }
            
            ML.assert(error == nil, message: error!.localizedDescription)
        }
        
        managedObjectContext_ = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        
        managedObjectContext_.persistentStoreCoordinator = storeCoordinator
        
        
    }
    
    public func insertManagedObject(className:MLString)->AnyObject{
        
        let managedObject:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(className, inManagedObjectContext: managedObjectContext_) as NSManagedObject
        
        save()
        
        return managedObject
        
    }
    
    public func deleteObject(managedObject:NSManagedObject){
        
        managedObjectContext_.deleteObject(managedObject)
        save()
        
    }
    
    public func deleteAllObjects(className : MLString){
        
        var allObjs : NSArray = fetchEntities(className, withPredicate: nil, withSorter : nil, nbObj : nil)
        
        for o in allObjs {
            var manObj : NSManagedObject = o as NSManagedObject
            managedObjectContext_.deleteObject(manObj)
            
        }
        
        save()
    }
    
    public func save()->Bool{
        if managedObjectContext_.save(nil){
            return true
        }else{
            return false
        }
    }
    
    public func fetchObjectById(objectId : NSManagedObjectID)->NSManagedObject{
        
        var fetchedObj : NSManagedObject = managedObjectContext_.existingObjectWithID(objectId, error: nil)!
        
        return fetchedObj
    }
    
    public func fetchEntities(className : MLString)->NSArray!{
        return fetchEntities(className, withPredicate : nil, withSorter : nil, nbObj: nil)
    }
    
    public func fetchEntities(className : MLString, withPredicate predicate:NSPredicate?, withSorter sorter : [NSSortDescriptor]?, nbObj : Int? )->NSArray!{
        
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        
        let entetyDescription : NSEntityDescription = NSEntityDescription.entityForName(className, inManagedObjectContext: managedObjectContext_)!
        
        fetchRequest.entity = entetyDescription
        
        if(nbObj != nil){
            fetchRequest.fetchLimit = nbObj!
            
        }
        
        if (predicate != nil){
            fetchRequest.predicate = predicate!
        }
        
        if (sorter != nil){
            fetchRequest.sortDescriptors = sorter!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        
        let items : NSArray = managedObjectContext_.executeFetchRequest(fetchRequest, error: nil)!
        
        
        return items
    }
    
    public class func makeContainPredicate( field : MLString, containsName : MLString)->NSPredicate{
        
        var predicateString : MLString = field+" CONTAINS '"+containsName+"' "
        
        var predicate : NSPredicate = NSPredicate(format: predicateString)!
        
        return predicate
        
    }
    
    public class func makeEqualsPredicate( field : MLString, equalsName : MLString)->NSPredicate{
        
        var predicateString : MLString = field+" LIKE '"+equalsName+"' "
        
        var predicate : NSPredicate = NSPredicate(format: predicateString)!
        
        return predicate
        
    }
    
    
    
    // Mark: - Service
    
    private func directoryForDatabaseFilename()->MLString{
        return NSHomeDirectory().stringByAppendingString("/Library/Private Documents")
    }
    
    
    private func databaseFilename()->MLString{
        return "database.sqlite";
    }
    
    
}
