//
//  ExampleModel.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/7.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

struct ExampleModel {
    enum HeaderType {
        case state
        case normal
        case gif
        case hiddenTime
        case hiddenStateTime
        case customTitle
        case customUI
    }
    enum FooterType {
        case autoState
        case gif
        case hiddenTitle
        case finish
        case enableAutoLoad
        case customTitle
        case hiddenWhenLoad
        case auto1
        case auto2
        case diy1
        case diy2
    }
    var title: String?
    var headerType: HeaderType = .normal
    var footerType: FooterType = .autoState
}
