//
//  OnlineViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class OnlineViewController: BaseButtonBarPagerTabStripViewController<OnlineMenuCell> {
    
    @IBOutlet weak var searchView: OnlineSearchView!
    
    var store: OnlineStore!
    var action: OnlineAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .background
        view.backgroundColor = .background
        
        searchView.configure(searchBar: searchController.searchBar)
        
        if let homeController = controllers[0] as? HomeViewController {
            homeController.delegate = self
        }
        
        bindStore()
        bindAction()
    }
    
    // MARK: Search Bar
    
    var searchController: UISearchController!
    
    // MARK: Menu
    
    var controllers: [UIViewController] = []
    
    override func configure(cell: OnlineMenuCell, for indicatorInfo: IndicatorInfo) {
        cell.configure(title: indicatorInfo.title, image: indicatorInfo.image) { [weak self] label in
            cell.label.font = self?.settings.style.buttonBarItemFont ?? cell.label.font
            cell.label.textColor = self?.settings.style.buttonBarItemTitleColor ?? cell.label.textColor
        }
        
        cell.contentView.backgroundColor = settings.style.buttonBarItemBackgroundColor ?? cell.contentView.backgroundColor
        cell.backgroundColor = settings.style.buttonBarItemBackgroundColor ?? cell.backgroundColor
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return controllers
    }

}

extension OnlineViewController: HomeViewControllerDelegate {
    
    func homeViewControllerSwitchToPlaylistViewController(_ controller: HomeViewController) {
        moveToViewController(at: 1, animated: true)
    }
    
    func homeViewControllerSwitchToVideoViewController(_ controller: HomeViewController) {
        moveToViewController(at: 3, animated: true)
    }
    
    func homeViewControllerSwitchToTopicViewController(_ controller: HomeViewController) {
        moveToViewController(at: 6, animated: true)
    }
    
    func homeViewControllerSwitchToSongViewController(_ controller: HomeViewController) {
        moveToViewController(at: 2, animated: true)
    }
    
}

extension OnlineViewController {
    
    func bindStore() {
        
    }
    
}

extension OnlineViewController {
    
    func bindAction() {
        searchView.action = action.searchBarClicked()
    }
    
}
