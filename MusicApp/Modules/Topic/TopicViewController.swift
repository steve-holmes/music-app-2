//
//  TopicViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import Action
import RxDataSources
import NSObject_Rx

class TopicViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var initialIndicatorView = InitialActivityIndicatorView()
    
    fileprivate var refreshControl = OnlineRefreshControl()
    
    var store: TopicStore!
    var action: TopicAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        
        bindStore()
        bindAction()
    }
    
    fileprivate var TopicsSection = 1
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<TopicSection> = { [weak self] in
        let dataSource = RxTableViewSectionedReloadDataSource<TopicSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, topic in
            guard let controller = self else { fatalError("Unexpected View Controller") }
            
            return dataSource.configureCell(for: tableView, at: indexPath, in: controller, animated: true) {
                if indexPath.section == controller.TopicsSection {
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopicCell.self), for: indexPath)
                    if let cell = cell as? TopicCell {
                        cell.configure(name: topic.name, image: topic.avatar)
                        controller.action.onRegisterTopicPreview.execute(cell)
                    }
                    return cell
                }
                fatalError("Unexpected Topic Section")
            }
        }
        
        return dataSource
    }()

}

extension TopicViewController: UITableViewDelegate, TopicCellOptions {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let AdvertisementSection = 0
        let TopicSection = 1
        
        switch indexPath.section {
        case AdvertisementSection: return 50
        case TopicSection:
            let itemHeight = height(of: tableView)
            return itemHeight + itemPadding
        default:
            fatalError("Unexpected Row Height")
        }
    }
    
}

extension TopicViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Chủ đề"
    }
    
}

extension TopicViewController {
    
    func bindStore() {
        store.topics.asObservable()
            .filter { $0.count > 0 }
            .do(onNext: { [weak self] _ in
                self?.initialIndicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            })
            .map { topics in [
                TopicSection(model: "Advertisement", items: [Topic(id: "ad", name: "Advertisement", avatar: "not_found")]),
                TopicSection(model: "Topics", items: topics)
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
        
        store.topics.asObservable()
            .filter { $0.count == 0 }
            .subscribe(onNext: { [weak self] _ in
                self?.initialIndicatorView.startAnimating(in: self?.view)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    func bindAction() {
        action.onLoad.execute(())
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(action.onPullToRefresh.inputs)
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx.modelSelected(Topic.self)
            .subscribe(action.onTopicDidSelect.inputs)
            .addDisposableTo(rx_disposeBag)
    }
    
}
