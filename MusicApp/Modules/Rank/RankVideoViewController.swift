//
//  RankVideoViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

class RankVideoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: RankHeaderView!
    
    private let headerCell = UITableViewCell(style: .default, reuseIdentifier: "HeaderCell")
    
    var store: RankVideoStore!
    var action: RankVideoAction!
    
    // MARK: Properties
    
    var videos: [Video] {
        get { return store.videos.value }
        set { store.videos.value = newValue }
    }
    
    var country: String!
    
    // MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        tableView.delegate = self
        
        headerView.configure(country: country, type: kRankTypeVideo)
        headerView.configureAnimation(with: tableView)
        
        bindStore()
        bindAction()
    }
    
    private var headerViewNeedsToUpdate = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if headerViewNeedsToUpdate {
            headerView.frame.size.height = tableView.bounds.size.height / 4
            headerViewNeedsToUpdate = false
        }
    }
    
    // MARK: Target Actions
    
    @IBAction func backButtonTapped(_ backButton: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Data Sources
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Video>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Video>>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, video in
            if indexPath.section == 0 {
                return self.headerCell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RankVideoCell.self), for: indexPath)
            if let cell = cell as? RankVideoCell {
                cell.configure(name: video.name, singer: video.singer, image: video.avatar)
                cell.rank = indexPath.row + 1
            }
            return cell
        }
        
        return dataSource
    }()

}

extension RankVideoViewController: UITableViewDelegate {
    
    private var headerHeight: CGFloat { return tableView.bounds.height / 4 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return headerHeight
        }
        
        return 80
    }
    
}

extension RankVideoViewController {
    
    func bindStore() {
        store.videos.asObservable()
            .filter { $0.count > 0 }
            .map { videos in [
                SectionModel(model: "Header", items: [
                    Video(id: "header", name: "Header", singer: "header", avatar: "not_found", time: "00:00")
                ]),
                SectionModel(model: "Videos", items: videos)
                ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension RankVideoViewController {
    
    func bindAction() {
        
    }
    
}
