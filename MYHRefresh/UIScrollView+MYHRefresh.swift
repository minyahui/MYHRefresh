//
//  UIScrollView+MYHRefresh.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/5.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit
extension NSObject {
    
    /// 交换实例方法
    /// - Parameter method1: 方法1
    /// - Parameter method2: 方法2
    public class func exchangeInstance(method1: Selector, method2: Selector) {
        if let m1 = class_getInstanceMethod(self, method1), let m2 = class_getInstanceMethod(self, method2) {
            method_exchangeImplementations(m1, m2)
        }
    }
    
    /// 交换类方法
    /// - Parameter method1: 方法1
    /// - Parameter method2: 方法2
    public class func exchangeClass(method1: Selector, method2: Selector) {
        if let m1 = class_getClassMethod(self, method1), let m2 = class_getClassMethod(self, method2) {
            method_exchangeImplementations(m1, m2)
        }
    }
    
    /// 交换实例方法
    /// - Parameter method1: 方法1
    /// - Parameter method2: 方法2
    public func exchangeInstance(method1: Selector, method2: Selector) {
        if let m1 = class_getInstanceMethod(self.classForCoder, method1), let m2 = class_getInstanceMethod(self.classForCoder, method2) {
            method_exchangeImplementations(m1, m2)
        }
    }
    
    /// 交换类方法
    /// - Parameter method1: 方法1
    /// - Parameter method2: 方法2
    public func exchangeClass(method1: Selector, method2: Selector) {
        if let m1 = class_getClassMethod(self.classForCoder, method1), let m2 = class_getClassMethod(self.classForCoder, method2) {
            method_exchangeImplementations(m1, m2)
        }
    }
    
}

extension UIScrollView {
    public var myh_header: MYHRefreshHeader? {
        set {
            
            if newValue != self.myh_header {
                self.myh_header?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                self.willChangeValue(forKey: "myh_header")
                objc_setAssociatedObject(self, &(MYHRefreshHeaderKey), newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                self.didChangeValue(forKey: "myh_header")
            }
        }
        get {
            return objc_getAssociatedObject(self, &(MYHRefreshHeaderKey)) as? MYHRefreshHeader
        }
    }
    
    
    public var myh_footer: MYHRefreshFooter? {
        set {
            
            if newValue != self.myh_footer {
                self.myh_footer?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                
                self.willChangeValue(forKey: "myh_footer")
                objc_setAssociatedObject(self, &(MYHRefreshFooterKey), newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                self.didChangeValue(forKey: "myh_footer")
            }
        }
        get {
            return objc_getAssociatedObject(self, &(MYHRefreshFooterKey)) as? MYHRefreshFooter
        }
    }
    
    public func myh_totalDataCount() -> Int {
        var totalCount = 0
        if let tableView = self as? UITableView {
            for section in 0 ..< tableView.numberOfSections {
                totalCount += tableView.numberOfRows(inSection: section)
            }
        } else if let collectionView = self as? UICollectionView {
            for section in 0 ..< collectionView.numberOfSections {
                totalCount += collectionView.numberOfItems(inSection: section)
            }
        }
        return totalCount
    }
    
    /// 必须调用exchangeReloadData方法，这个闭包h才会回调
    public var myh_reloadDataBlock: ((_ totalDataCount: Int)->())? {
        set {
            self.willChangeValue(forKey: "myh_reloadDataBlock")
            objc_setAssociatedObject(self, &(MYHRefreshReloadDataBlockKey), newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.didChangeValue(forKey: "myh_reloadDataBlock")
        }
        get {
            return objc_getAssociatedObject(self, &(MYHRefreshReloadDataBlockKey)) as? ((Int) -> ())
        }
    }
    
    public func executeReloadDataBlock() {
        self.myh_reloadDataBlock?(self.myh_totalDataCount())
    }
}
extension UITableView {
    public func exchangeReloadData() {
        self.exchangeInstance(method1: #selector(self.reloadData), method2: #selector(self.myh_reloadData))
    }
    
    @objc private func myh_reloadData() {
        self.myh_reloadData()
        self.executeReloadDataBlock()
    }
}

extension UICollectionView {
    public func exchangeReloadData() {
        self.exchangeInstance(method1: #selector(self.reloadData), method2: #selector(self.myh_reloadData))
    }
    
    @objc private func myh_reloadData() {
        self.myh_reloadData()
        self.executeReloadDataBlock()
    }
}
