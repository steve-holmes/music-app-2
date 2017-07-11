//
//  RankViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa
import Action
import RxDataSources
import NSObject_Rx

class RankViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var initialIndicatorView = InitialActivityIndicatorView()
    
    var store: RankStore!
    var action: RankAction!
    
    lazy var categoryHeaderView: CategoryHeaderView = {
        let categoryView = CategoryHeaderView(size: CGSize(
            width: self.tableView.bounds.size.width,
            height: CategoryHeaderView.defaultHeight
        ))
        categoryView.buttonText = "Quốc gia"
        return categoryView
    }()
    
    fileprivate var refreshControl = OnlineRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.estimatedRowHeight = 180
        tableView.addSubview(refreshControl)
        
        bindStore()
        bindAction()
    }
    
    fileprivate let AdvertisementSection = 0
    fileprivate let RanksSection = 1
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<RankSection> = {
        let dataSource = RxTableViewSectionedReloadDataSource<RankSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, item in
            if indexPath.section == self.AdvertisementSection {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AdvertisementCell.self), for: indexPath)
                (cell as? AdvertisementCell)?.configure(rootViewController: self)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RanksCell.self), for: indexPath)
            if let ranksCell = cell as? RanksCell {
                ranksCell.rank = item.rank
                ranksCell.rankImage = item.image
                
                if item.items.count >= 4 {
                    ranksCell.firstItem = item.items[0]
                    ranksCell.secondItem = item.items[1]
                    ranksCell.thirdItem = item.items[2]
                    ranksCell.fourthItem = item.items[3]
                }
            }
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, section in dataSource[section].model }
        
        return dataSource
    }()

}

extension RankViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == self.RanksSection {
            let categoryAction = CocoaAction {
                return self.action.onCategoriesButtonTap.execute(()).map { _ in }
            }
            categoryHeaderView.configure(text: store.category.value.name, action: categoryAction)
            return categoryHeaderView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == self.RanksSection { return CategoryHeaderView.defaultHeight }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let AdvertisementSection = 0
        let RanksSection = 1
        
        switch indexPath.section {
        case AdvertisementSection: return 50
        case RanksSection:
            return UITableViewAutomaticDimension
        default:
            fatalError("Unexpected Row Height")
        }
    }
    
}

extension RankViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "BXH"
    }
    
}

extension RankViewController {
    
    func bindStore() {
        store.songs.asObservable()
            .filter { $0.count == 0 }
            .subscribe(onNext: { [weak self] _ in
                self?.initialIndicatorView.startAnimating(in: self?.view)
            })
            .addDisposableTo(rx_disposeBag)
        
        let songs = store.songs.asObservable()
        let playlists = store.playlists.asObservable()
        let videos = store.videos.asObservable()
        
        Observable
            .combineLatest(songs, playlists, videos) { songs, playlists, videos in
                (songs: songs, playlists: playlists, videos: videos)
            }
            .filter { $0.songs.count >= 4 && $0.playlists.count >= 4 && $0.videos.count >= 4 }
            .do(onNext: { [weak self] _ in
                self?.initialIndicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            })
            .map { itemInfos -> [RanksItem] in
                let (songs, playlists, videos) = itemInfos
                
                var songImage = ""
                switch self.store.category.value.link {
                case kRankCountryVietnam:   songImage = "BXH-App-Banner_VN_V"
                case kRankCountryEurope:    songImage = "BXH-App-Banner_US_V"
                case kRankCountryKorea:     songImage = "BXH-App-Banner_KR_V"
                default:    break
                }
                
                let songItems = songs[0..<4].map { song in song.name }
                let songRankItem = RanksItem(rank: "Song", image: songImage, items: songItems)
                
                let playlistItems = playlists[0..<4].map { playlist in playlist.name }
                let playlistRankItem = RanksItem(rank: "Playlist", image: playlists[0].avatar, items: playlistItems)
                
                let videoItems = videos[0..<4].map { video in video.name }
                let videoRankItem = RanksItem(rank: "Video", image: videos[0].avatar, items: videoItems)
                
                return [songRankItem, playlistRankItem, videoRankItem]
            }
            .map { rankItems -> [RankSection] in [
                RankSection(
                    model: "Advertisement",
                    items: [ RanksItem(rank: "ad", image: "not_found", items: ["ad"]) ]
                ),
                RankSection(model: "Rank", items: rankItems)
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
    }
    
    func bindAction() {
        action.onLoadCategories.execute(())
        
        let initialCategoryLoading = store.category.asObservable()
            .take(1)
            .map { category in category.link }
        
        let categoriesButtonTapLoading = action.onCategoriesButtonTap.elements
            .filter { info in info != nil }
            .map { category in category!.link }
        
        Observable.from([initialCategoryLoading, categoriesButtonTapLoading])
            .merge()
            .subscribe(action.onLoad.inputs)
            .addDisposableTo(rx_disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { [weak self] _ in self!.store.category.value.link }
            .subscribe(action.onPullToRefresh.inputs)
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx.itemSelected
            .filter { indexPath in indexPath.section == 1 && indexPath.row == 0 }
            .map { _ in }
            .subscribe(action.onSongCellTap.inputs)
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx.itemSelected
            .filter { indexPath in indexPath.section == 1 && indexPath.row == 1 }
            .map { _ in }
            .subscribe(action.onPlaylistCellTap.inputs)
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx.itemSelected
            .filter { indexPath in indexPath.section == 1 && indexPath.row == 2 }
            .map { _ in }
            .subscribe(action.onVideoCellTap.inputs)
            .addDisposableTo(rx_disposeBag)
    }
    
}
