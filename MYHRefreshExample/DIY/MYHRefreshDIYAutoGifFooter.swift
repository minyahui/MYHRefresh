//
//  MYHRefreshDIYAutoGifFooter.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/11.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

class MYHRefreshDIYAutoGifFooter: MYHRefreshAutoGifFooter {

    override func prepare() {
        
        var refreshingImages = [UIImage]()
        for i in 1 ... 3 {
            if let image = UIImage.init(named: "dropdown_loading_0\(i)") {
                refreshingImages.append(image)
            }
        }
        self.setImages(images: refreshingImages, state: .refreshing)
        super.prepare()
    }

}
