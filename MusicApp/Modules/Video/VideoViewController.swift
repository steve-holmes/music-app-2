//
//  VideoViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/10/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import Action
import RxDataSources
import NSObject_Rx

class VideoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var initialIndicatorView = InitialActivityIndicatorView()
    fileprivate var loadingIndicatorView = LoadingActivityIndicatorView()
    
    lazy var categoryHeaderView: CategoryHeaderView = CategoryHeaderView(size: CGSize(
        width: self.tableView.bounds.size.width,
        height: CategoryHeaderView.defaultHeight
    ))
    
    fileprivate var refreshControl = OnlineRefreshControl()
    
    var store: VideoStore!
    var action: VideoAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        
        bindStore()
        bindAction()
    }
    
    fileprivate var VideosSection = 1
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<VideoSection> = { [weak self] in
        let dataSource = RxTableViewSectionedReloadDataSource<VideoSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, video in
            guard let controller = self else { fatalError("Unexpected View Controller") }
            
            return dataSource.configureCell(for: tableView, at: indexPath, in: controller, animated: controller.store.loadMoreEnabled.value) {
                if indexPath.section == controller.VideosSection {
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideoCell.self), for: indexPath)
                    if let cell = cell as? VideoCell {
                        cell.configure(name: video.name, singer: video.singer, image: video.avatar, time: video.time)
                    }
                    return cell
                }
                fatalError("Unexpected Video Section")
            }
        }
        
        dataSource.titleForHeaderInSection = { dataSource, section in dataSource[section].model }
        
        return dataSource
    }()

}

extension VideoViewController: UITableViewDelegate, VideoCellOptions {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == self.VideosSection {
            let categoryAction = CocoaAction {
                return self.action.onCategoriesButtonTap.execute(()).map { _ in }
            }
            categoryHeaderView.configure(text: store.category.value.name, action: categoryAction)
            return categoryHeaderView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == self.VideosSection { return CategoryHeaderView.defaultHeight }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let AdvertisementSection = 0
        let VideoSection = 1
        let LoadMoreSection = 2
        
        switch indexPath.section {
        case AdvertisementSection: return 50
        case LoadMoreSection: return 44
        case VideoSection:
            let itemHeight = height(of: tableView)
            return itemHeight + itemPadding
        default:
            fatalError("Unexpected Row Height")
        }
    }
    
}

extension VideoViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Video"
    }
    
}

extension VideoViewController {
    
    func bindStore() {
        store.videos.asObservable()
            .filter { $0.count > 0 }
            .do(onNext: { [weak self] _ in
                self?.initialIndicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            })
            .map { videos in [
                VideoSection(model: "Advertisement", items: [Video(id: "ad", name: "Advertisement", singer: "Google", avatar: "not_found", time: "00:00")]),
                VideoSection(model: "Videos", items: videos),
                VideoSection(model: "Load More", items: [Video(id: "load", name: "Load More", singer: "Table View", avatar: "not_found", time: "00:00")])
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
        
        store.videos.asObservable()
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
        
        store.videoLoading.asObservable()
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
    }
    
}
