//
//  UIScrollView+MYHExtension.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/5.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

extension UIScrollView {
    open var myh_inset: UIEdgeInsets {
        get{
            if #available(iOS 11.0, *) {
                return self.adjustedContentInset
            }
            return self.contentInset
        }
    }
    
    open var myh_inset_top: CGFloat {
        get {
            return self.myh_inset.top
        }
        set {
            var inset = self.contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                inset.top -= (self.adjustedContentInset.top - self.contentInset.top)
            }
            self.contentInset = inset
        }
    }
    
    open var myh_inset_bottom: CGFloat {
        get {
            return self.myh_inset.bottom
        }
        set {
            var inset = self.contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
            }
            self.contentInset = inset
        }
    }
    
    open var myh_inset_left: CGFloat {
        get {
            return self.myh_inset.left
        }
        set {
            var inset = self.contentInset
            inset.left = newValue
            if #available(iOS 11.0, *) {
                inset.left -= (self.adjustedContentInset.left - self.contentInset.left)
            }
            self.contentInset = inset
        }
    }
    
    open var myh_inset_right: CGFloat {
        get {
            return self.myh_inset.right
        }
        set {
            var inset = self.contentInset
            inset.right = newValue
            if #available(iOS 11.0, *) {
                inset.right -= (self.adjustedContentInset.right - self.contentInset.right)
            }
            self.contentInset = inset
        }
    }
    
    open var myh_offset_x: CGFloat {
        get {
            return self.contentOffset.x
        }
        set {
            var offset = self.contentOffset
            offset.x = newValue
            self.contentOffset = offset
        }
    }
    
    open var myh_offset_y: CGFloat {
        get {
            return self.contentOffset.y
        }
        set {
            var offset = self.contentOffset
            offset.y = newValue
            self.contentOffset = offset
        }
    }
    
    open var myh_content_width: CGFloat {
        get {
            return self.contentSize.width
        }
        set {
            var contentSize = self.contentSize
            contentSize.width = newValue
            self.contentSize = contentSize
        }
    }
    
    open var myh_content_height: CGFloat {
        get {
            return self.contentSize.height
        }
        set {
            var contentSize = self.contentSize
            contentSize.height = newValue
            self.contentSize = contentSize
        }
    }
}
