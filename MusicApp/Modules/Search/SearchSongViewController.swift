//
//  SearchSongViewController.swift
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
import Action
import NSObject_Rx

class SearchSongViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var store: SearchStore!
    var action: SearchAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        bindStore()
        bindAction()
    }
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Song>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Song>>()

        dataSource.configureCell = { dataSource, tableView, indexPath, song in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SongCell.self), for: indexPath)
            if let cell = cell as? SongCell {
                let contextAction = CocoaAction { _ in
                    self.action.onContextButtonTap.execute(song).map { _ in }
                }
                cell.configure(name: song.name, singer: song.singer, contextAction: contextAction)
            }
            return cell
        }
        
        return dataSource
    }()

}

extension SearchSongViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

extension SearchSongViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Bài hát"
    }
    
}

extension SearchSongViewController {
    
    func bindStore() {
        store.songs.asObservable()
            .filter { $0.count > 0 }
            .map { songs in [SectionModel(model: "Songs", items: songs)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension SearchSongViewController {
    
    func bindAction() {
        tableView.rx.modelSelected(Song.self)
            .subscribe(onNext: { [weak self] song in
                self?.searchController.setInactive()
                self?.action.songDidSelect.execute(song)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}
