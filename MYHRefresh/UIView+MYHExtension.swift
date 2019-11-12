//
//  UIView+MYHExtension.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/5.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

extension UIView {
     public var myh_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var newFrame = self.frame
            newFrame.origin.x = newValue
            self.frame = newFrame
        }
    }
    
    public var myh_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var newFrame = self.frame
            newFrame.origin.y = newValue
            self.frame = newFrame
        }
    }
    
    public var myh_w: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var newFrame = self.frame
            newFrame.size.width = newValue
            self.frame = newFrame
        }
    }
    
    public var myh_h: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var newFrame = self.frame
            newFrame.size.height = newValue
            self.frame = newFrame
        }
    }
    
    public var myh_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var newFrame = self.frame
            newFrame.size = newValue
            self.frame = newFrame
        }
    }
    
    public var myh_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var newFrame = self.frame
            newFrame.origin = newValue
            self.frame = newFrame
        }
    }
    
    /**
     获取视图所在的控制器(UIViewController)
     */
    public func myh_getCurrentViewController() -> UIViewController?{
        var next: UIView? = self
        repeat{
            if let responder = next?.next{
                if responder is UIViewController{
                    return responder as? UIViewController
                }
            }
            next = next?.superview
            
        }while next != nil
        
        return nil
        
    }
}

extension UILabel {
    static func myh_init() -> UILabel {
        let label = UILabel.init()
        label.font = MYHRefreshLabelFont
        label.textColor = UIColor.myh_black
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }
    
    func myh_textWidth() -> CGFloat {
        var stringWidth: CGFloat = 0
        let size = CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        if let str = self.text, str.count > 0, let f = self.font {
            stringWidth = (str as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : f], context: nil).size.width
        }
        return stringWidth
    }
    
}

extension UIColor {
    class var myh_black: UIColor {
        get {
            if MYH_isLight {
                return UIColor.black
            }
            return UIColor.white
        }
    }

    class var myh_white: UIColor {
        get {
            if MYH_isLight {
                return UIColor.white
            }
            return UIColor.black
        }
    }

}
