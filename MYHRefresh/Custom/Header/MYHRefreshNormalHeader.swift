//
//  MYHRefreshNormalHeader.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/6.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

public class MYHRefreshNormalHeader: MYHRefreshStateHeader {
    
    public weak var arrowImageView: UIImageView! {
        if self.privateArrowImageView == nil {
            let imageView = UIImageView.init(image: Bundle.myh_arrowImage(arrowType: self.arrowType))
            self.addSubview(imageView)
            self.privateArrowImageView = imageView
        }
        return self.privateArrowImageView
    }
    private weak var privateArrowImageView: UIImageView?
    
    public weak var loadingView: UIActivityIndicatorView! {
        get {
            if self.privateLoadingView == nil {
                let loadingView = UIActivityIndicatorView.init(style: self.activityIndicatorViewStyle)
                loadingView.hidesWhenStopped = true
                loadingView.tintColor = UIColor.myh_black
                self.addSubview(loadingView)
                self.privateLoadingView = loadingView
            }
            return self.privateLoadingView
        }
    }
    private weak var privateLoadingView: UIActivityIndicatorView?
    
    override public var arrowType: MYHRefreshComponent.ArrowType{
        willSet{
            super.arrowType = newValue
            self.arrowImageView.image = Bundle.myh_arrowImage(arrowType: newValue)
            switch newValue {
            case .black:
                self.loadingView.tintColor = UIColor.myh_black
                self.loadingView.color = UIColor.myh_black
                break
            case .white:
                self.loadingView.tintColor = UIColor.myh_white
                self.loadingView.color = UIColor.myh_white
                break
            }
        }
    }
    
    public var activityIndicatorViewStyle: UIActivityIndicatorView.Style = .gray {
        didSet{
            self.loadingView.style = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    override public var state: MYHRefreshComponent.RefreshState {
        willSet {
            if self.state == newValue {
                return
            }
            let oldValue = self.state
            super.state = newValue
            if newValue == .idle {
                if oldValue == .refreshing {
                    self.arrowImageView.transform = CGAffineTransform.identity
                    UIView.animate(withDuration: MYHRefreshSlowAnimationDuration, animations: {
                        self.loadingView.alpha = 0
                    }) { (finish) in
                        if oldValue != .idle {
                            return
                        }
                        self.loadingView.alpha = 1
                        self.loadingView.stopAnimating()
                        self.arrowImageView.isHidden = false
                    }
                } else {
                    self.loadingView.stopAnimating()
                    self.arrowImageView.isHidden = false
                    
                    UIView.animate(withDuration: MYHRefreshFastAnimationDuration) {
                        self.arrowImageView.transform = CGAffineTransform.identity
                    }
                }
            } else if newValue == .pulling {
                self.loadingView.stopAnimating()
                self.arrowImageView.isHidden = false
                UIView.animate(withDuration: MYHRefreshFastAnimationDuration) {
                    self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi)
//                        CATransform3DGetAffineTransform(CATransform3DMakeRotation(-CGFloat.pi, 0, 1, 0))
                }
            } else if newValue == .refreshing {
                self.loadingView.alpha = 1 // 防止refreshing -> idle的动画完毕动作没有被执行
                self.loadingView.startAnimating()
                self.arrowImageView.isHidden = true
            }
        }
    }
    
    override public func placeSubviews() {
        super.placeSubviews()
        // 箭头的中心点
        var arrowCenterX = self.myh_w * 0.5
        if self.stateLabel.isHidden == false {
            let stateWidth = self.stateLabel.myh_textWidth()
            var timeWidth: CGFloat = 0
            if self.lastUpdatedTimeLabel.isHidden == false {
                timeWidth = self.lastUpdatedTimeLabel.myh_textWidth()
            }
            let textWidth = stateWidth > timeWidth ? stateWidth : timeWidth
            arrowCenterX -= textWidth * 0.5 + self.labelLeftInset
        }
        
        let arrowCenterY = self.myh_h * 0.5
        let arrowCenter = CGPoint.init(x: arrowCenterX, y: arrowCenterY)
        if self.arrowImageView.constraints.count == 0, let size = self.arrowImageView.image?.size {
            self.arrowImageView.myh_size = size
            self.arrowImageView.center = arrowCenter
        }
        
        if self.loadingView.constraints.count == 0 {
            self.loadingView.center = arrowCenter
        }
        
        self.arrowImageView.tintColor = self.stateLabel.textColor
    }
    
    override public func prepare() {
        
        if #available(iOS 13.0, *) {
            self.activityIndicatorViewStyle = .medium
        } else {
            self.activityIndicatorViewStyle = .gray
        }
        super.prepare()
    }
}
