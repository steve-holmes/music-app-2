//
//  PlaylistViewController.swift
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

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var initialIndicatorView = InitialActivityIndicatorView()
    fileprivate var loadingIndicatorView = LoadingActivityIndicatorView()
    
    lazy var categoryHeaderView: CategoryHeaderView = CategoryHeaderView(size: CGSize(
        width: self.tableView.bounds.size.width,
        height: CategoryHeaderView.defaultHeight
    ))
    
    fileprivate var refreshControl = OnlineRefreshControl()
    
    var store: PlaylistStore!
    var action: PlaylistAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        
        bindStore()
        bindAction()
    }
    
    fileprivate let PlaylistsSection = 1
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<PlaylistCollectionSection> = { [weak self] in
        let dataSource = RxTableViewSectionedReloadDataSource<PlaylistCollectionSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, playlists in
            guard let controller = self else { fatalError("Unexpected View Controller") }
                
            return dataSource.configureCell(for: tableView, at: indexPath, in: controller, animated: controller.store.loadMoreEnabled.value) {
                if indexPath.section == controller.PlaylistsSection {
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaylistCell.self), for: indexPath)
                    if let cell = cell as? PlaylistCell {
                        cell.registerPreviewAction = controller.action.onRegisterPlaylistPreview()
                        cell.didSelectAction = controller.action.onPlaylistDidSelect()
                        cell.playAction = controller.action.onPlaylistPlayButtonTapped()
                        
                        cell.playlists = playlists
                    }
                    return cell
                }
                fatalError("Unexpected Playlist Section")
            }
        }
        
        dataSource.titleForHeaderInSection = { dataSource, section in dataSource[section].model }
        
        return dataSource
    }()
}

extension PlaylistViewController: UITableViewDelegate, PlaylistCellOptions {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == self.PlaylistsSection {
            let categoryAction = CocoaAction {
                return self.action.onCategoriesButtonTap.execute(()).map { _ in }
            }
            categoryHeaderView.configure(text: store.category.value.name, action: categoryAction)
            return categoryHeaderView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == self.PlaylistsSection { return CategoryHeaderView.defaultHeight }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let AdvertisementSection = 0
        let PlaylistSection = 1
        let LoadMoreSection = 2
        
        switch indexPath.section {
        case AdvertisementSection: return 50
        case LoadMoreSection: return 44
        case PlaylistSection:
            let itemHeight = height(of: tableView)
            let items = self.store.playlists.value.count
            let lines = (items % itemsPerLine == 0) ? (items / itemsPerLine) : (items / itemsPerLine + 1)
            return CGFloat(lines) * itemHeight + CGFloat(lines + 1) * itemPadding
        default:
            fatalError("Unexpected Row Height")
        }
    }
    
}

extension PlaylistViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Playlist"
    }
    
}

extension PlaylistViewController {
    
    func bindStore() {
        store.playlists.asObservable()
            .filter { $0.count > 0 }
            .do(onNext: { [weak self] _ in
                self?.initialIndicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            })
            .map { playlists in PlaylistCollection(playlists: playlists) }
            .map { collection -> [PlaylistCollectionSection] in [
                PlaylistCollectionSection(model: "Advertisement", items: [PlaylistCollection(playlists: [
                    Playlist(id: "ad1", name: "Advertisement", singer: "Google", avatar: "not_found")
                ])]),
                PlaylistCollectionSection(model: "Playlists", items: [collection]),
                PlaylistCollectionSection(model: "Load More", items: [PlaylistCollection(playlists: [
                    Playlist(id: "load1", name: "Load More", singer: "Table View", avatar: "not_found")
                ])])
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
        
        store.playlists.asObservable()
            .filter { $0.count == 0 }
            .subscribe(onNext: { [weak self] _ in
                self?.initialIndicatorView.startAnimating(in: self?.view)
            })
            .addDisposableTo(rx_disposeBag)
        
        store.category.asObservable()
            .subscribe(onNext: { [weak self] category in
                self?.categoryHeaderView.text = category.name
            })
            .addDisposableTo(rx_disposeBag)
        
        store.playlistLoading.asObservable()
            .skip(3)
            .subscribe(onNext: { [weak self] loading in
                if loading {
                    self?.loadingIndicatorView.startAnimation(in: self?.view); return
                }
                self?.loadingIndicatorView.stopAnimation()
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            })
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
            .shareReplayLatestWhileConnected()
        
        Observable.from([initialCategoryLoading, categoriesButtonTapLoading])
            .merge()
            .subscribe(action.onLoad.inputs)
            .addDisposableTo(rx_disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { [weak self] _ in self!.store.category.value.link }
            .subscribe(action.onPullToRefresh.inputs)
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx.willDisplayCell
            .filter { _, indexPath in indexPath.section == 2 }
            .filter { [weak self] _, _ in self?.store.loadMoreEnabled.value ?? true }
            .map { [weak self] _ in self!.store.category.value.link }
            .subscribe(action.onLoadMore.inputs)
            .addDisposableTo(rx_disposeBag)
    }
    
}
