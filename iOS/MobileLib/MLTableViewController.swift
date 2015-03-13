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


public class MLTableViewController :
    UITableViewController,
    UISearchBarDelegate,
UISearchDisplayDelegate {
    
    
    typealias DelegateType = SearchTableViewControllerDelegate
    public typealias ListDataType = DelegateType.DataType
    public typealias ListType = DelegateType.DataTypeList
    
    //Mark: - Lists
    var list = ListType()
    var filteredList = ListType()
    public var delegateController = SearchTableViewControllerDelegate()
    public var errorTitle = ""
    
    func getList(tableView: UITableView)->ListType{
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return filteredList
        } else {
            return list
        }
        
    }
    
    //Mark: - Delegate Should be a class variable but seems
    //to be a compiler bug that connot compile
    func  controllerDelegate()->DelegateType{
        return delegateController
    }
    
    func loadDataFunc(dataList : ListType){
        list = dataList
        tableView.reloadData()
    }
    
    public func viewDidAppearImpl(){
        controllerDelegate().loadData(self.loadDataFunc)
        tableView.reloadData()
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        TryCatch.try({ () -> Void in
            
            self.viewDidAppearImpl()
            
            
            },catch: { (exception) -> Void in
                MLPopup.display(self.errorTitle, message: exception.reason!, view: self)
            }){ () -> Void in
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        TryCatch.try({ () -> Void in
            
            if let searchController = self.searchDisplayController {
                
                var searchFrame = searchController.searchBar.frame

                let showBar = self.controllerDelegate().showSearchBar()
                searchController.searchBar.hidden = !showBar
                if( showBar == false){
                    searchFrame.size.height = 0
                }else{
                    searchFrame.size.height = 44
                }
                
                searchController.searchBar.frame = searchFrame

            }
            
            self.refreshControl = UIRefreshControl()
            self.refreshControl?.addTarget(self, action: "pullToRefreshList:", forControlEvents: UIControlEvents.ValueChanged)
            
            self.controllerDelegate().completeViewDidLoad(self.loadDataFunc)
            
            },catch: { (exception) -> Void in
                MLPopup.display(self.errorTitle, message: exception.reason!, view: self)
            }){ () -> Void in
        }

        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        TryCatch.try({ () -> Void in
            
            if(self.refreshControl != nil){
                self.refreshControl!.endRefreshing()
            }
            
            },catch: { (exception) -> Void in
                MLPopup.display(self.errorTitle, message: exception.reason!, view: self)
            }){ () -> Void in
        }

    }
    
    //Mark: - Pull to refresh
    func pullToRefreshList(sender: AnyObject) {
        
        TryCatch.try({ () -> Void in
            
            var completion = {(dataList : ListType)->Void in
                self.refreshControl!.endRefreshing()
                self.loadDataFunc(dataList)
            }
            
            self.controllerDelegate().refreshList(completion)
            
            },catch: { (exception) -> Void in
                MLPopup.display(self.errorTitle, message: exception.reason!, view: self)
            }){ () -> Void in
        }
        
    }
    
    //Mark: - Search delegate
    
    func filterList(name : MLString){
        
        TryCatch.try({ () -> Void in
            
            self.filteredList = self.list.filter({( listData : ListDataType) -> Bool in
                let stringMatch = listData.name.lowercaseString.rangeOfString(name.lowercaseString)
                return (stringMatch != nil)
            })
            
            
            },catch: { (exception) -> Void in
                MLPopup.display(self.errorTitle, message: exception.reason!, view: self)
            }){ () -> Void in
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        TryCatch.try({ () -> Void in
            
            self.filterList(searchString)
            
            },catch: { (exception) -> Void in
                MLPopup.display(self.errorTitle, message: exception.reason!, view: self)
            }){ () -> Void in
        }
        
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        
        TryCatch.try({ () -> Void in
            
            self.filterList(self.searchDisplayController!.searchBar.text)
            
            },catch: { (exception) -> Void in
                MLPopup.display(self.errorTitle, message: exception.reason!, view: self)
            }){ () -> Void in
        }
        
        return true
    }

    
    
    //Mark: - TableView delegate
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var nb = self.getList(tableView).count
        return nb
    }
    
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return controllerDelegate().cellSize()
    }
    
    override public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return false
        } else {
            return true
        }

    }
    
    override public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        TryCatch.try({ () -> Void in
            
            if (editingStyle == UITableViewCellEditingStyle.Delete) {
                
                var selctedItem = self.list[indexPath.row]
                
                self.controllerDelegate().deleteItem(selctedItem)
                
                self.list.removeAtIndex(indexPath.row)
                self.tableView.reloadData()
            }
            
            
            },catch: { (exception) -> Void in
                MLPopup.display(self.errorTitle, message: exception.reason!, view: self)
            }){ () -> Void in
        }
    }
    override public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        TryCatch.try({ () -> Void in
            
            var selctedItem = self.getList(tableView)[indexPath.row]
            
            self.controllerDelegate().accessorySelected(selctedItem)
            
            },catch: { (exception) -> Void in
                MLPopup.display(self.errorTitle, message: exception.reason!, view: self)
            }){ () -> Void in
        }
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
         let cell = self.tableView.dequeueReusableCellWithIdentifier(controllerDelegate().cellIdentifier(), forIndexPath: indexPath) as UITableViewCell
        
        TryCatch.try({ () -> Void in
            
            var item = self.getList(tableView)[indexPath.row]
            
            self.controllerDelegate().setCell(cell, item : item )
            
            },catch: { (exception) -> Void in
                MLPopup.display(self.errorTitle, message: exception.reason!, view: self)
            }){ () -> Void in
        }
        
        return cell
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        TryCatch.try({ () -> Void in
            
            var selctedItem = self.getList(tableView)[indexPath.row]

            self.controllerDelegate().itemSelected(selctedItem)
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            },catch: { (exception) -> Void in
                MLPopup.display(self.errorTitle, message: exception.reason!, view: self)
            }){ () -> Void in
        }
        
        
    }
    
    
    
    
    
    
}

