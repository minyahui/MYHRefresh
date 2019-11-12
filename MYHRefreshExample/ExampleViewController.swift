//
//  ExampleViewController.swift
//  MYHRefresh
//
//  Created by hs015 on 2019/11/7.
//  Copyright © 2019 MYH. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
    var dataCount = 10
    
    @IBOutlet weak var tableView: UITableView!
    var exampleModel: ExampleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.handleTableView()
    }
    

    @IBAction func stop(_ sender: UIBarButtonItem) {
        self.tableView.myh_header?.endRefreshing {[weak self] () in
            print("头部-手动结束刷新了")
            self?.dataCount = 10
            self?.tableView.reloadData()
            self?.tableView.myh_footer?.isHidden = false
            self?.tableView.myh_footer?.resetNoMoreData()
        }
        self.tableView.myh_footer?.endRefreshing {[weak self] () in
            print("尾部-手动结束刷新了")
            guard let strongSelf = self else { return }
            strongSelf.dataCount += 10
            strongSelf.tableView.reloadData()
        }
    }
    @IBAction func begin(_ sender: UIBarButtonItem) {
        self.tableView.myh_header?.beginRefreshing {
            print("头部-开始刷新了")
        }
    }
    
    deinit {
        debugPrint(#function,self.classForCoder)
    }

}

extension ExampleViewController {
    func handleTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        guard let model = self.exampleModel else { return }
        self.handleTableHeader(headerType: model.headerType)
        self.handleTableFooter(footerType: model.footerType)
    }
    
    @objc func loadHeaderData() {
        print("头部-刷新中。。。。")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.tableView.myh_header?.endRefreshing { [weak self] () in
                print("头部-自动结束刷新了")
                self?.dataCount = 10
                self?.tableView.reloadData()
                self?.tableView.myh_footer?.isHidden = false
                self?.tableView.myh_footer?.resetNoMoreData()
            }
        }
    }
    
    @objc func loadMoreData() {
        print("尾部-刷新中。。。。")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.tableView.myh_footer?.endRefreshing { [weak self] () in
                print("尾部-自动结束刷新了")
                guard let strongSelf = self else { return }
                strongSelf.dataCount += 10
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    @objc func loadOnceData() {
        print("尾部-刷新中。。。。")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.tableView.myh_footer?.endRefreshing { [weak self] () in
                print("尾部-自动结束刷新了")
                guard let strongSelf = self else { return }
                strongSelf.dataCount += 10
                strongSelf.tableView.reloadData()
                strongSelf.tableView.myh_footer?.isHidden = true
            }
        }
    }
    @objc func loadLastData() {
        print("尾部-刷新中。。。。")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.tableView.myh_footer?.endRefreshing { [weak self] () in
                print("尾部-自动结束刷新了")
                guard let strongSelf = self else { return }
                strongSelf.dataCount += 10
                strongSelf.tableView.reloadData()
                strongSelf.tableView.myh_footer?.isHidden = false
                strongSelf.tableView.myh_footer?.endRefreshingWithNoMoreData()
            }
        }
    }
}

extension ExampleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "item")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "item")
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
}

extension ExampleViewController {
    func handleTableHeader(headerType: ExampleModel.HeaderType) {
        switch headerType {
        case .state:
            let header = MYHRefreshStateHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            })
            header.arrowType = .white
            self.tableView.myh_header = header
            break
        case .normal:
            self.tableView.myh_header = MYHRefreshNormalHeader.init(target: self, refreshingAction: #selector(self.loadHeaderData), arrowType: .white)
            break
        case .gif:
            /// 这个建议继承，重写prepare方法
            let header = MYHRefreshDIYAutoGifHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            }, arrowType: .white)
            self.tableView.myh_header = header
            break
        case .hiddenTime:
            let header = MYHRefreshNormalHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            }, arrowType: .white)
            header.lastUpdatedTimeLabel.isHidden = true
            header.isAutomaticallyChangeAlpha = true
            self.tableView.myh_header = header
            break
        case .hiddenStateTime:
            let header = MYHRefreshNormalHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            }, arrowType: .white)
            header.lastUpdatedTimeLabel.isHidden = true
            header.stateLabel.isHidden = true
            self.tableView.myh_header = header
            break
        case .customTitle:
            let header = MYHRefreshNormalHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            }, arrowType: .white)
            header.setTitle("自定义-下拉刷新", state: .idle)
            header.setTitle("自定义-释放就能刷新", state: .pulling)
            header.setTitle("自定义-加载中", state: .refreshing)
            header.stateLabel.textColor = UIColor.red
            self.tableView.myh_header = header
            break
        case .customUI:
            self.tableView.myh_header = MYHRefreshDIYUIHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            })
            break
        }
    }
    
    func handleTableFooter(footerType: ExampleModel.FooterType) {
        switch footerType {
        
        case .autoState:
            let footer = MYHRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] () in
                self?.loadMoreData()
            })
            footer.arrowType = .white
            self.tableView.myh_footer = footer
            break
        case .gif:
            self.tableView.myh_footer = MYHRefreshDIYAutoGifFooter.init(refreshingBlock: { [weak self] () in
                self?.loadMoreData()
            })
            break
        case .hiddenTitle:
            let footer = MYHRefreshDIYAutoGifFooter.init(refreshingBlock: { [weak self] () in
                self?.loadMoreData()
            })
            footer.isRefreshingTitleHidden = true
            self.tableView.myh_footer = footer
            break
        case .finish:
            self.tableView.myh_footer = MYHRefreshAutoNormalFooter.init { [weak self] () in
                self?.loadLastData()
            }
            break
        case .enableAutoLoad:
            let footer = MYHRefreshAutoNormalFooter.init { [weak self] () in
                self?.loadMoreData()
            }
            footer.isAutomaticallyRefresh = false
            self.tableView.myh_footer = footer
            break
        case .customTitle:
            let footer = MYHRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] () in
                self?.loadMoreData()
            })
            footer.setTitle("自定义-上拉就能刷新", state: .idle)
            footer.setTitle("自定义-加载中", state: .refreshing)
            footer.setTitle("自定义-没有数据了", state: .noMoreData)
            footer.stateLabel.textColor = UIColor.red
            self.tableView.myh_footer = footer
            break
        case .hiddenWhenLoad:
            self.tableView.myh_footer = MYHRefreshAutoNormalFooter.init { [weak self] () in
                self?.loadOnceData()
            }
            break
        case .auto1:
            self.tableView.myh_footer = MYHRefreshBackNormalFooter.init(target: self, refreshingAction: #selector(self.loadMoreData), arrowType: .white)
            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
            self.tableView.myh_footer?.ignoredScrollViewContentInsetBottom = 30
            break
        case .auto2:
            self.tableView.myh_footer = MYHRefreshDIYBackGifFooter.init(refreshingBlock: { [weak self] () in
                self?.loadMoreData()
            })
            self.tableView.myh_footer?.isAutomaticallyChangeAlpha = true
            break
        case .diy1:
            self.tableView.myh_footer = MYHRefreshDIYAutoFooter.init(target: self, refreshingAction: #selector(self.loadMoreData))
            break
        case .diy2:
            self.tableView.myh_footer = MYHRefreshDIYBackFooter.init(target: self, refreshingAction: #selector(self.loadMoreData))
            break
        }
    }
}
