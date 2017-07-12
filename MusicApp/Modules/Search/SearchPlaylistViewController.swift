//
//  SearchPlaylistViewController.swift
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

class SearchPlaylistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var store: SearchStore!
    var action: SearchAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        bindStore()
        bindAction()
    }
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Playlist>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Playlist>>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, playlist in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaylistDetailCell.self), for: indexPath)
            if let cell = cell as? PlaylistDetailCell {
                cell.configure(name: playlist.name, singer: playlist.singer, image: playlist.avatar)
            }
            return cell
        }
        
        return dataSource
    }()

}

extension SearchPlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension SearchPlaylistViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Playlist"
    }
    
}

extension SearchPlaylistViewController {
    
    func bindStore() {
        store.playlists.asObservable()
            .filter { $0.count > 0 }
            .filter { [weak self] _ in (self?.store.state.value ?? .all) == .playlist }
            .map { playlists in [SectionModel(model: "Playlists", items: playlists)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension SearchPlaylistViewController {
    
    func bindAction() {
        
    }
    
}
