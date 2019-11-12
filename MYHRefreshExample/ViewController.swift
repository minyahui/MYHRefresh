//
//  ViewController.swift
//  MYHRefreshExample
//
//  Created by hs015 on 2019/11/12.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableView.myh_header = MYHRefreshNormalHeader.init(refreshingBlock: { [weak self]() in
            print("头部-刷新中。。。。")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self?.tableView.myh_header?.endRefreshing {
                    print("头部-自动结束刷新了")
                }
            }
        })
        
        self.tableView.myh_footer = MYHRefreshBackNormalFooter.init(refreshingBlock: {  [weak self]() in
            print("尾部-刷新中。。。。")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                print("尾部-自动结束刷新了-没有更多数据了")
                self?.tableView.myh_footer?.endRefreshingWithNoMoreData()
            }
        }, arrowType: .black)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as?  ExampleViewController, let cell = sender as? UITableViewCell {
            let tag = cell.tag
            let section = tag / 10000
            let row = tag % 10000
            vc.exampleModel = self.dataArray[section][row]
        }
    }

    @IBAction func stop(_ sender: UIBarButtonItem) {
        self.tableView.myh_header?.endRefreshing {
            print("头部-手动结束刷新了")
        }
        self.tableView.myh_footer?.endRefreshing {
            print("尾部-手动结束刷新了")
        }
    }
    @IBAction func begin(_ sender: UIBarButtonItem) {
        self.tableView.myh_header?.beginRefreshing {
            print("头部-开始刷新了")
        }
    }
    
    lazy var dataArray: [[ExampleModel]] = {
        let array = [[ExampleModel.init(title: "状态刷新", headerType: .state, footerType: .autoState),
         ExampleModel.init(title: "普通刷新（默认）", headerType: .normal, footerType: .autoState),
         ExampleModel.init(title: "Gif刷新", headerType: .gif, footerType: .autoState),
         ExampleModel.init(title: "普通刷新（默认）-隐藏时间", headerType: .hiddenTime, footerType: .autoState),
         ExampleModel.init(title: "普通刷新（默认）-隐藏时间状态", headerType: .hiddenStateTime, footerType: .autoState),
         ExampleModel.init(title: "普通刷新（默认）-自定义文字", headerType: .customTitle, footerType: .autoState),
         ExampleModel.init(title: "普通刷新（默认）-自定义控件", headerType: .customUI, footerType: .autoState)
        ],
        [
        ExampleModel.init(title: "默认", headerType: .normal, footerType: .autoState),
        ExampleModel.init(title: "动画图片", headerType: .normal, footerType: .gif),
        ExampleModel.init(title: "隐藏刷新状态的文字", headerType: .normal, footerType: .hiddenTitle),
        ExampleModel.init(title: "全部加载完毕", headerType: .normal, footerType: .finish),
        ExampleModel.init(title: "禁止自动加载", headerType: .normal, footerType: .enableAutoLoad),
        ExampleModel.init(title: "自定义文字", headerType: .normal, footerType: .customTitle),
        ExampleModel.init(title: "加载后隐藏", headerType: .normal, footerType: .hiddenWhenLoad),
        ExampleModel.init(title: "自动回弹的上拉01", headerType: .normal, footerType: .auto1),
        ExampleModel.init(title: "自动回弹的上拉02", headerType: .normal, footerType: .auto2),
        ExampleModel.init(title: "自定义控件（自动刷新）", headerType: .normal, footerType: .diy1),
        ExampleModel.init(title: "自定义控件（自动回弹）", headerType: .normal, footerType: .diy2)
        ]]
        return array
    }()
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        cell.textLabel?.text = self.dataArray[indexPath.section][indexPath.row].title
        cell.tag = indexPath.row + 10000 * indexPath.section
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "头部刷新样式"
        } else if section == 1 {
            return "尾部刷新样式"
        }
        return nil
    }
}



