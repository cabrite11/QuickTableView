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

    func insert(cellModel: UITableViewCellModel, atIndexPath indexPath: IndexPath) {

        assert(dataSourceArray.isKind(of: NSMutableArray.self), "dataSourceArray must NOT be nil")
        
        dataSourceArray.insert(cellModel, at: indexPath.row)
        self.beginUpdates()
        self.insertRows(at: [indexPath], with: .automatic)
        self.endUpdates()
    }
    
    func insert(cellModels: [UITableViewCellModel], atIndexPath indexPath: IndexPath) {

        assert(dataSourceArray.isKind(of: NSMutableArray.self), "dataSourceArray must NOT be nil")

        var indexPaths: [IndexPath] = []
        var index = indexPath.row
        for cellModel in cellModels {
            dataSourceArray.insert(cellModel, at: index)
            indexPaths.append(IndexPath(row: index, section: 0))
            index = index + 1
        }
        
        self.beginUpdates()
        self.insertRows(at: indexPaths, with: .automatic)
        self.endUpdates()
    }
}

// MARK:- Append

extension UITableView {
    
    func append(cellModel: UITableViewCellModel) {
        
        assert(dataSourceArray.isKind(of: NSMutableArray.self), "dataSourceArray must NOT be nil")
        
        let indexPath = IndexPath(row: dataSourceArray.count, section: 0)
        dataSourceArray.add(cellModel)
        
        self.beginUpdates()
        self.insertRows(at: [indexPath], with: .automatic)
        self.endUpdates()
        
    }
    
    func append(cellModels: [UITableViewCellModel]) {
        
        assert(dataSourceArray.isKind(of: NSMutableArray.self), "dataSourceArray must NOT be nil")
        
        guard cellModels.count > 0 else {
            return
        }
        
        let indexPaths = NSMutableArray()
        let dataSourceArrayCount = dataSourceArray.count
        for index in dataSourceArrayCount ... dataSourceArrayCount + cellModels.count - 1 {
            let indexPath = IndexPath(row: index, section: 0)
            indexPaths.add(indexPath)
        }
        
        for cellModel in cellModels {
            dataSourceArray.add(cellModel)
        }
        
        self.beginUpdates()
        self.insertRows(at: NSArray.init(array: indexPaths) as! [IndexPath], with: .automatic)
        self.endUpdates()
    }
    
}

// MARK:- Replace

extension UITableView {
    
    func replace(cellModel: UITableViewCellModel, atIndexPath indexPath: IndexPath) {
        
        assert(dataSourceArray.isKind(of: NSMutableArray.self), "dataSourceArray must NOT be nil")
        
        dataSourceArray.replaceObject(at: indexPath.row, with: cellModel)
        
        self.beginUpdates()
        self.reloadRows(at: [indexPath], with: .automatic)
        self.endUpdates()
        
    }
    
    func replace(new newCellModels: [UITableViewCellModel],
                 old oldCellModels: [UITableViewCellModel]) {
        
        assert(dataSourceArray.isKind(of: NSMutableArray.self), "dataSourceArray must NOT be nil")
        
        var indexPaths: [IndexPath] = []
        for index in 0 ... newCellModels.count {
            guard index < oldCellModels.count else {
                break
            }

            let indexInDataSource = dataSourceArray.index(of: oldCellModels[index])
            indexPaths.append(IndexPath(row: indexInDataSource, section: 0))
            dataSourceArray.replaceObject(at: indexInDataSource, with: newCellModels[index])
        }

        self.beginUpdates()
        self.reloadRows(at: indexPaths, with: .automatic)
        self.endUpdates()
    }
    
}


// MARK:- Remove

extension UITableView {
    
    func remove(cellModel: UITableViewCellModel) {
        
        assert(dataSourceArray.isKind(of: NSMutableArray.self), "dataSourceArray must NOT be nil")
        
        if dataSourceArray.contains(cellModel) {
            let index = dataSourceArray.index(of: cellModel)
            remove(atIndexPath: IndexPath(row: index, section: 0))
        }
    }
    
    func remove(atIndexPath indexPath: IndexPath) {
        
        assert(dataSourceArray.isKind(of: NSMutableArray.self), "dataSourceArray must NOT be nil")
        
        guard indexPath.row < dataSourceArray.count else {
            return
        }
        
        dataSourceArray.removeObject(at: indexPath.row)
        self.beginUpdates()
        self.deleteRows(at: [indexPath], with: .automatic)
        self.endUpdates()
    }
    
    func remove(cellModels: [UITableViewCellModel]) {
        
        assert(dataSourceArray.isKind(of: NSMutableArray.self), "dataSourceArray must NOT be nil")
        
        var mIndexPaths: [IndexPath] = []
        for cellModel in cellModels {
            if dataSourceArray.contains(cellModel) {
                let index = dataSourceArray.index(of: cellModel)
                mIndexPaths.append(IndexPath(row: index, section: 0))
            }
        }
        remove(atIndexPaths: mIndexPaths)
        
    }
    
    func remove(atIndexPaths indexPaths: [IndexPath]) {
        
        assert(dataSourceArray.isKind(of: NSMutableArray.self), "dataSourceArray must NOT be nil")
        
        var mIndexPaths: [IndexPath] = []
        for indexPath in indexPaths {
            if indexPath.row < dataSourceArray.count {
                dataSourceArray.removeObject(at: indexPath.row)
                mIndexPaths.append(indexPath)
            }
        }
        self.beginUpdates()
        self.deleteRows(at: mIndexPaths, with: .automatic)
        self.endUpdates()
    }
    
}
