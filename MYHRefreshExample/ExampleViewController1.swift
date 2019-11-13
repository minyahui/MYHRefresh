//
//  ExampleViewController1.swift
//  MYHRefreshExample
//
//  Created by hs015 on 2019/11/13.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

class ExampleViewController1: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.myh_header = MYHRefreshNormalHeader.init(refreshingBlock: {  [weak self]() in
            print("头部-刷新中。。。。")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self?.tableView.myh_header?.endRefreshing {
                    self?.tableView.myh_footer?.resetNoMoreData()
                    print("头部-自动结束刷新了")
                }
            }
        }, arrowType: .white, isFollowDrakMode: false)
        
        self.tableView.myh_footer = MYHRefreshBackNormalFooter.init(refreshingBlock: {  [weak self]() in
            print("尾部-刷新中。。。。")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                print("尾部-自动结束刷新了-没有更多数据了")
                self?.tableView.myh_footer?.endRefreshingWithNoMoreData()
            }
        }, arrowType: .white, isFollowDrakMode: false)
    }

}
