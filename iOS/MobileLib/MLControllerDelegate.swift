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


public class BaseData {
    public init(){}
    public var name : MLString = MLString()
}

public class SearchTableViewControllerDelegate{
    
    public typealias DataType = BaseData
    public typealias DataTypeList = [BaseData]
    
    public var controller : UIViewController?
    
    public init(){}
    
    public func refreshList(refreshCompletion : ((dataList : DataTypeList)->Void)){
        fatalError("SearchTableViewControllerDelegate.refreshList not implemented")
    }
    public func loadData(refreshCompletion : ((dataList : DataTypeList)->Void)){
        fatalError("SearchTableViewControllerDelegate.loadData not implemented")
    }
    public func completeViewDidLoad(refreshCompletion : ((dataList : DataTypeList)->Void)){
        fatalError("SearchTableViewControllerDelegate.completeViewDidLoad not implemented")
    }
    public func cellSize()->CGFloat{
        fatalError("SearchTableViewControllerDelegate.cellSize not implemented")
        return 0.0
    }
    public func deleteItem(item : DataType){
        fatalError("SearchTableViewControllerDelegate.deleteItem not implemented")
    }
    public func accessorySelected(item : DataType){
        fatalError("SearchTableViewControllerDelegate.accessorySelected not implemented")
    }
    public func cellIdentifier()->MLString{
        fatalError("SearchTableViewControllerDelegate.cellIdentifier not implemented")
        return ""
    }
    public func setCell( cell : UITableViewCell, item : DataType){
        fatalError("SearchTableViewControllerDelegate.setCell not implemented")
    }
    public func itemSelected(item : DataType){
        fatalError("SearchTableViewControllerDelegate.itemSelected not implemented")
    }
    public func showSearchBar()->Bool{
        fatalError("SearchTableViewControllerDelegate.showSearchBar not implemented")
    }
}