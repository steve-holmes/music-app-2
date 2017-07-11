//
//  SongViewController.swift
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

class SongViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var initialIndicatorView = InitialActivityIndicatorView()
    fileprivate var loadingIndicatorView = LoadingActivityIndicatorView()
    
    lazy var categoryHeaderView: CategoryHeaderView = CategoryHeaderView(size: CGSize(
        width: self.tableView.bounds.size.width,
        height: CategoryHeaderView.defaultHeight
    ))
    
    fileprivate var refreshControl = OnlineRefreshControl()
    
    var store: SongStore!
    var action: SongAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        
        bindStore()
        bindAction()
    }
    
    fileprivate var SongsSection = 1
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SongSection> = { [weak self] in
        let dataSource = RxTableViewSectionedReloadDataSource<SongSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, song in
            guard let controller = self else { fatalError("Unexpected View Controller") }
            
            return dataSource.configureCell(for: tableView, at: indexPath, in: controller, animated: controller.store.loadMoreEnabled.value) {
                if indexPath.section == controller.SongsSection {
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SongCell.self), for: indexPath)
                    if let cell = cell as? SongCell {
                        let contextAction = CocoaAction { _ in
                            return controller.action.onContextButtonTap.execute((song, controller)).map { _ in }
                        }
                        cell.configure(name: song.name, singer: song.singer, contextAction: contextAction)
                    }
                    return cell
                }
                fatalError("Unexpected Song Section")
            }
        }
        
        dataSource.titleForHeaderInSection = { dataSource, section in dataSource[section].model }
        
        return dataSource
    }()

}

extension SongViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == self.SongsSection {
            let categoryAction = CocoaAction {
                return self.action.onCategoriesButtonTap.execute(()).map { _ in }
            }
            categoryHeaderView.configure(text: store.category.value.name, action: categoryAction)
            return categoryHeaderView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == self.SongsSection { return CategoryHeaderView.defaultHeight }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let AdvertisementSection = 0
        let SongSection = 1
        let LoadMoreSection = 2
        
        switch indexPath.section {
        case AdvertisementSection: return 50
        case LoadMoreSection: return 44
        case SongSection: return 44
        default:
            fatalError("Unexpected Row Height")
        }
    }
    
}

extension SongViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Bài hát"
    }
    
}

extension SongViewController {
    
    func bindStore() {
        store.songs.asObservable()
            .filter { $0.count > 0 }
            .do(onNext: { [weak self] _ in
                self?.initialIndicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            })
            .map { songs in [
                SongSection(model: "Advertisement", items: [Song(id: "ad", name: "Advertisement", singer: "Google")]),
                SongSection(model: "Songs", items: songs),
                SongSection(model: "Load More", items: [Song(id: "load", name: "Load More", singer: "Table View")])
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
        
        store.songs.asObservable()
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
        
        store.songLoading.asObservable()
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
        
        tableView.rx.modelSelected(Song.self)
            .subscribe(action.onSongDidSelect.inputs)
            .addDisposableTo(rx_disposeBag)
    }
    
}
