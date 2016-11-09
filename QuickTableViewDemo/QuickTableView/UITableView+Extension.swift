//
//  UITableView+Extension.swift
//  CrazyPanda
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Goluk. All rights reserved.
//

import UIKit
import ObjectiveC


class UITableViewCellModel: NSObject{
    
    var cachedHeight: CGFloat?
    
}

var AssociatedObjectKey: UInt8 = 0
extension UITableView {
    
    var dataSourceArray: NSMutableArray {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKey) as! NSMutableArray
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK:- Insert

extension UITableView {

    func insert(cellModel cellModel: UITableViewCellModel, atIndexPath indexPath: NSIndexPath) {

        assert(dataSourceArray.isKindOfClass(NSMutableArray), "dataSourceArray must NOT be nil")
        
        dataSourceArray.insertObject(cellModel, atIndex: indexPath.row)
        self.beginUpdates()
        self.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.endUpdates()
    }
    
    func insert(cellModels cellModels: [UITableViewCellModel], atIndexPath indexPath: NSIndexPath) {

        assert(dataSourceArray.isKindOfClass(NSMutableArray), "dataSourceArray must NOT be nil")

        var indexPaths: [NSIndexPath] = []
        var index = indexPath.row
        for cellModel in cellModels {
            dataSourceArray.insertObject(cellModel, atIndex: index)
            indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
            index = index + 1
        }
        
        self.beginUpdates()
        self.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        self.endUpdates()
    }
}

// MARK:- Append

extension UITableView {
    
    func append(cellModel cellModel: UITableViewCellModel) {
        
        assert(dataSourceArray.isKindOfClass(NSMutableArray), "dataSourceArray must NOT be nil")
        
        let indexPath = NSIndexPath(forRow: dataSourceArray.count, inSection: 0)
        dataSourceArray.addObject(cellModel)
        
        self.beginUpdates()
        self.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.endUpdates()
        
    }
    
    func append(cellModels cellModels: [UITableViewCellModel]) {
        
        assert(dataSourceArray.isKindOfClass(NSMutableArray), "dataSourceArray must NOT be nil")
        
        guard cellModels.count > 0 else {
            return
        }
        
        let indexPaths = NSMutableArray()
        let dataSourceArrayCount = dataSourceArray.count
        for index in dataSourceArrayCount ... dataSourceArrayCount + cellModels.count - 1 {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            indexPaths.addObject(indexPath)
        }
        
        for cellModel in cellModels {
            dataSourceArray.addObject(cellModel)
        }
        
        self.beginUpdates()
        self.insertRowsAtIndexPaths(NSArray.init(array: indexPaths) as! [NSIndexPath], withRowAnimation: .Automatic)
        self.endUpdates()
    }
    
}

// MARK:- Replace

extension UITableView {
    
    func replace(cellModel cellModel: UITableViewCellModel, atIndexPath indexPath: NSIndexPath) {
        
        assert(dataSourceArray.isKindOfClass(NSMutableArray), "dataSourceArray must NOT be nil")
        
        dataSourceArray.replaceObjectAtIndex(indexPath.row, withObject: cellModel)
        
        self.beginUpdates()
        self.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.endUpdates()
        
    }
    
    func replace(new newCellModels: [UITableViewCellModel],
                 old oldCellModels: [UITableViewCellModel]) {
        
        assert(dataSourceArray.isKindOfClass(NSMutableArray), "dataSourceArray must NOT be nil")
        
        var indexPaths: [NSIndexPath] = []
        for index in 0 ... newCellModels.count {
            guard index < oldCellModels.count else {
                break
            }

            let indexInDataSource = dataSourceArray.indexOfObject(oldCellModels[index])
            indexPaths.append(NSIndexPath(forRow: indexInDataSource, inSection: 0))
            dataSourceArray.replaceObjectAtIndex(indexInDataSource, withObject: newCellModels[index])
        }

        self.beginUpdates()
        self.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        self.endUpdates()
    }
    
}


// MARK:- Remove

extension UITableView {
    
    func remove(cellModel cellModel: UITableViewCellModel) {
        
        assert(dataSourceArray.isKindOfClass(NSMutableArray), "dataSourceArray must NOT be nil")
        
        if dataSourceArray.containsObject(cellModel) {
            let index = dataSourceArray.indexOfObject(cellModel)
            remove(atIndexPath: NSIndexPath(forRow: index, inSection: 0))
        }
    }
    
    func remove(atIndexPath indexPath: NSIndexPath) {
        
        assert(dataSourceArray.isKindOfClass(NSMutableArray), "dataSourceArray must NOT be nil")
        
        guard indexPath.row < dataSourceArray.count else {
            return
        }
        
        dataSourceArray.removeObjectAtIndex(indexPath.row)
        self.beginUpdates()
        self.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.endUpdates()
    }
    
    func remove(cellModels cellModels: [UITableViewCellModel]) {
        
        assert(dataSourceArray.isKindOfClass(NSMutableArray), "dataSourceArray must NOT be nil")
        
        var mIndexPaths: [NSIndexPath] = []
        for cellModel in cellModels {
            if dataSourceArray.containsObject(cellModel) {
                let index = dataSourceArray.indexOfObject(cellModel)
                mIndexPaths.append(NSIndexPath(forRow: index, inSection: 0))
            }
        }
        remove(atIndexPaths: mIndexPaths)
        
    }
    
    func remove(atIndexPaths indexPaths: [NSIndexPath]) {
        
        assert(dataSourceArray.isKindOfClass(NSMutableArray), "dataSourceArray must NOT be nil")
        
        var mIndexPaths: [NSIndexPath] = []
        for indexPath in indexPaths {
            if indexPath.row < dataSourceArray.count {
                dataSourceArray.removeObjectAtIndex(indexPath.row)
                mIndexPaths.append(indexPath)
            }
        }
        self.beginUpdates()
        self.deleteRowsAtIndexPaths(mIndexPaths, withRowAnimation: .Automatic)
        self.endUpdates()
    }
    
}
