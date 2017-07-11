//
//  SingerViewController.swift
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

class SingerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var initialIndicatorView = InitialActivityIndicatorView()
    fileprivate var loadingIndicatorView = LoadingActivityIndicatorView()
    
    lazy var categoryHeaderView: CategoryHeaderView = {
        let categoryView = CategoryHeaderView(size: CGSize(
            width: self.tableView.bounds.size.width,
            height: CategoryHeaderView.defaultHeight
        ))
        categoryView.buttonText = "A - Z"
        return categoryView
    }()
    
    fileprivate var refreshControl = OnlineRefreshControl()
    
    var store: SingerStore!
    var action: SingerAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        
        bindStore()
        bindAction()
    }
    
    fileprivate var SingersSection = 1
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SingerCollectionSection> = { [weak self] in
        let dataSource = RxTableViewSectionedReloadDataSource<SingerCollectionSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, singers in
            guard let controller = self else { fatalError("Unexpected View Controller") }
            
            return dataSource.configureCell(for: tableView, at: indexPath, in: controller, animated: controller.store.loadMoreEnabled.value) {
                if indexPath.section == controller.SingersSection {
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SingerCell.self), for: indexPath)
                    if let cell = cell as? SingerCell {
                        cell.registerPreviewAction = controller.action.onRegisterSingerPreview()
                        cell.didSelectAction = controller.action.onSingerDidSelect()
                        
                        cell.singers = singers
                    }
                    return cell
                }
                fatalError("Unexpected Singer Section")
            }
        }
        
        dataSource.titleForHeaderInSection = { dataSource, section in dataSource[section].model }
        
        return dataSource
    }()

}

extension SingerViewController: UITableViewDelegate, SingerCellOptions {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == self.SingersSection {
            let categoryAction = CocoaAction {
                return self.action.onCategoriesButtonTap.execute(()).map { _ in }
            }
            categoryHeaderView.configure(text: store.category.value.name, action: categoryAction)
            return categoryHeaderView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == self.SingersSection { return CategoryHeaderView.defaultHeight }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let AdvertisementSection = 0
        let SingerSection = 1
        let LoadMoreSection = 2
        
        switch indexPath.section {
        case AdvertisementSection: return 50
        case LoadMoreSection: return 44
        case SingerSection:
            let itemHeight = height(of: tableView)
            let items = self.store.singers.value.count
            let lines = (items % itemsPerLine == 0) ? (items / itemsPerLine) : (items / itemsPerLine + 1)
            return CGFloat(lines) * itemHeight + CGFloat(lines + 1) * itemPadding
        default:
            fatalError("Unexpected Row Height")
        }
    }
    
}

extension SingerViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Nghệ sĩ"
    }
    
}

extension SingerViewController {
    
    func bindStore() {
        store.singers.asObservable()
            .filter { $0.count > 0 }
            .do(onNext: { [weak self] _ in
                self?.initialIndicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            })
            .map { singers in SingerCollection(singers: singers) }
            .map { collection -> [SingerCollectionSection] in [
                SingerCollectionSection(model: "Advertisement", items: [SingerCollection(singers: [
                    Singer(id: "ad1", name: "Advertisement", avatar: "not_found")
                ])]),
                SingerCollectionSection(model: "Singers", items: [collection]),
                SingerCollectionSection(model: "Load More", items: [SingerCollection(singers: [
                    Singer(id: "load1", name: "Load More", avatar: "not_found")
                ])])
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
        
        store.singers.asObservable()
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
        
        store.singerLoading.asObservable()
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
