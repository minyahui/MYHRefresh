//
//  MYHRefreshAutoNormalFooter.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/6.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

class MYHRefreshAutoNormalFooter: MYHRefreshAutoStateFooter {
    override var arrowType: MYHRefreshComponent.ArrowType {
        willSet {
            super.arrowType = newValue
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
    
    public var activityIndicatorViewStyle: UIActivityIndicatorView.Style = .gray {
        didSet{
            self.loadingView.style = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }

    override func prepare() {
        super.prepare()
        if #available(iOS 13.0, *) {
            self.activityIndicatorViewStyle = .medium
        } else {
            self.activityIndicatorViewStyle = .gray
        }
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if self.loadingView.constraints.count > 0 {
            return
        }
        var loadingCenterX = self.myh_w * 0.5
        if self.isRefreshingTitleHidden == false {
            loadingCenterX -= self.stateLabel.myh_textWidth() * 0.5 + self.labelLeftInset
        }
        let loadingCenterY = self.myh_h * 0.5
        self.loadingView.center = CGPoint.init(x: loadingCenterX, y: loadingCenterY)
    }
    
    override var state: MYHRefreshComponent.RefreshState {
        willSet{
            if newValue == self.state {
                return
            }
            if newValue == .noMoreData || newValue == .idle {
                self.loadingView.stopAnimating()
            } else {
                self.loadingView.startAnimating()
            }
            super.state = newValue
        }
    }
}
