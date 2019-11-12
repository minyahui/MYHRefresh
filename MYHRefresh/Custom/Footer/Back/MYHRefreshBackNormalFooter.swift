//
//  MYHRefreshBackNormalFooter.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/6.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

class MYHRefreshBackNormalFooter: MYHRefreshBackStateFooter {
    
    override var arrowType: MYHRefreshComponent.ArrowType {
        willSet {
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
    
    public weak var arrowImageView: UIImageView! {
        if self.privateArrowImageView == nil {
            let imageView = UIImageView.init(image: Bundle.myh_arrowImage(arrowType: self.arrowType))
            imageView.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi)
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
    
    override var state: MYHRefreshComponent.RefreshState {
        willSet {
            if newValue == self.state {
                return
            }
            let oldValue = self.state
            super.state = newValue
            // 根据状态做事情
            if newValue == .idle {
                if oldValue == .refreshing {
                    self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi)
                    UIView.animate(withDuration: MYHRefreshSlowAnimationDuration, animations: {
                        self.loadingView.alpha = 0
                    }) { (finish) in
                        // 防止动画结束后，状态已经不是MJRefreshStateIdle
                        if newValue != .idle {
                            return
                        }
                        self.loadingView.alpha = 1
                        self.loadingView.stopAnimating()
                        self.arrowImageView.isHidden = false
                    }
                } else {
                    self.arrowImageView.isHidden = false
                    self.loadingView.stopAnimating()
                    UIView.animate(withDuration: MYHRefreshFastAnimationDuration) {
                        self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi)
                    }
                }
                
            } else if newValue == .pulling {
                self.arrowImageView.isHidden = false
                self.loadingView.stopAnimating()
                UIView.animate(withDuration: MYHRefreshFastAnimationDuration) {
                    self.arrowImageView.transform = CGAffineTransform.identity
                }
            } else if newValue == .refreshing {
                self.arrowImageView.isHidden = true
                self.loadingView.startAnimating()
            } else if newValue == .noMoreData {
                self.arrowImageView.isHidden = true
                self.loadingView.stopAnimating()
            }
        }
    }

    override func prepare() {
        self.arrowType = .black
        if #available(iOS 13.0, *) {
            self.activityIndicatorViewStyle = .medium
        } else {
            self.activityIndicatorViewStyle = .gray
        }
        super.prepare()
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        // 箭头的中心点
        var arrowCenterX = self.myh_w * 0.5
        if self.stateLabel.isHidden == false {
            arrowCenterX -= self.labelLeftInset + self.stateLabel.myh_textWidth() * 0.5
        }
        let arrowCenterY = self.myh_h * 0.5
        let arrowCenter = CGPoint.init(x: arrowCenterX, y: arrowCenterY)
        
        // 箭头
        if self.arrowImageView.constraints.count == 0, let size = self.arrowImageView.image?.size {
            self.arrowImageView.myh_size = size
            self.arrowImageView.center = arrowCenter
        }
        
        // 圈圈
        if self.loadingView.constraints.count == 0 {
            self.loadingView.center = arrowCenter
        }
        
        self.arrowImageView.tintColor = self.stateLabel.textColor
        
    }
}
