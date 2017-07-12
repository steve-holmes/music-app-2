//
//  SearchVideoViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

class SearchVideoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var store: SearchStore!
    var action: SearchAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        bindStore()
        bindAction()
    }
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Video>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Video>>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, video in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideoItemCell.self), for: indexPath)
            if let cell = cell as? VideoItemCell {
                cell.configure(name: video.name, singer: video.singer, image: video.avatar)
            }
            return cell
        }
        
        return dataSource
    }()

}

extension SearchVideoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension SearchVideoViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Video"
    }
    
}

extension SearchVideoViewController {
    
    func bindStore() {
        store.videos.asObservable()
            .filter { $0.count > 0 }
            .map { videos in [SectionModel(model: "Videos", items: videos)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension SearchVideoViewController {
    
    func bindAction() {
        tableView.rx.modelSelected(Video.self)
            .subscribe(onNext: { [weak self] video in
                self?.action.videoDidSelect.execute(video)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}
