//
//  RankPlaylistViewController.swift
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

class RankPlaylistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: RankHeaderView!
    
    private let headerCell = UITableViewCell(style: .default, reuseIdentifier: "HeaderCell")
    
    var store: RankPlaylistStore!
    var action: RankPlaylistAction!
    
    // MARK: Properties
    
    var playlists: [Playlist] {
        get { return store.playlists.value }
        set { store.playlists.value = newValue }
    }
    
    var country: String!
    
    // MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        tableView.delegate = self
        
        headerView.configure(country: country, type: kRankTypePlaylist)
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
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Playlist>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Playlist>>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, playlist in
            if indexPath.section == 0 {
                return self.headerCell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RankPlaylistCell.self), for: indexPath)
            if let cell = cell as? RankPlaylistCell {
                cell.configure(name: playlist.name, singer: playlist.singer, image: playlist.avatar)
                cell.rank = indexPath.row + 1
                self.action.registerPlaylistPreview.execute((cell, self))
            }
            return cell
        }
        
        return dataSource
    }()

}

extension RankPlaylistViewController: UITableViewDelegate {
    
    private var headerHeight: CGFloat { return tableView.bounds.height / 4 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return headerHeight
        }
        return 60
    }
    
}

extension RankPlaylistViewController {
    
    func bindStore() {
        store.playlists.asObservable()
            .filter { $0.count > 0 }
            .map { playlists in [
                SectionModel(model: "Header", items: [
                    Playlist(id: "header", name: "Header", singer: "header", avatar: "not_found")
                ]),
                SectionModel(model: "Playlists", items: playlists)
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension RankPlaylistViewController {
    
    func bindAction() {
        tableView.rx.modelSelected(Playlist.self)
            .map { playlist in (playlist, self) }
            .subscribe(action.presentPlaylistDetail.inputs)
            .addDisposableTo(rx_disposeBag)
    }
    
}
