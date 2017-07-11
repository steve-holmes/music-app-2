//
//  HomeViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa
import RxDataSources
import Action
import NSObject_Rx

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var initialIndicatorView = InitialActivityIndicatorView()
    fileprivate var refreshControl = OnlineRefreshControl()
    
    var store: HomeStore!
    var action: HomeAction!
    
    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        
        bindStore()
        bindAction()
    }
    
    fileprivate let AdvertisementSection    = 0
    fileprivate let PageSection             = 1
    fileprivate let PlaylistSection         = 2
    fileprivate let VideoSection            = 3
    fileprivate let FilmSection             = 4
    fileprivate let TopicSection            = 5
    fileprivate let SongSection             = 6
    
    private lazy var advertisementCell: AdvertisementCell = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: AdvertisementCell.self)) as! AdvertisementCell
        cell.configure(rootViewController: self)
        return cell
    }()
    
    private lazy var pageCell: HomePageCell = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: HomePageCell.self)) as! HomePageCell
        cell.onPageDidSelect = self.action.onPageDidSelect()
        return cell
    }()
    
    private lazy var playlistCell: HomePlaylistCell = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: HomePlaylistCell.self)) as! HomePlaylistCell
        cell.onPlaylistDidSelect = self.action.onPlaylistDidSelect()
        return cell
    }()
    
    private lazy var videoCell: HomeVideoCell = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: HomeVideoCell.self)) as! HomeVideoCell
        cell.onVideoDidSelect = self.action.onVideoDidSelect()
        return cell
    }()
    
    private lazy var filmCell: HomeFilmCell = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: HomeFilmCell.self)) as! HomeFilmCell
        cell.onFilmDidSelect = self.action.onFilmDidSelect()
        return cell
    }()
    
    private lazy var topicCell: HomeTopicCell = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: HomeTopicCell.self)) as! HomeTopicCell
        cell.onTopicDidSelect = self.action.onTopicDidSelect()
        return cell
    }()
    
    private lazy var songCell: HomeSongCell = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: HomeSongCell.self)) as! HomeSongCell
        cell.onSongDidSelect = self.action.onSongDidSelect()
        return cell
    }()
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, HomeItem>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, HomeItem>>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, item in
            if indexPath.section == self.AdvertisementSection {
                return self.advertisementCell
            }
            
            if indexPath.section == self.PageSection, case let .pages(pages) = item {
                self.pageCell.pages = pages
                return self.pageCell
            }
            
            if indexPath.section == self.PlaylistSection, case let .playlists(playlists) = item {
                self.playlistCell.playlists = playlists
                return self.playlistCell
            }
            
            if indexPath.section == self.VideoSection, case let .videos(videos) = item {
                self.videoCell.videos = videos
                return self.videoCell
            }
            
            if indexPath.section == self.FilmSection, case let .films(films) = item {
                self.filmCell.films = films
                return self.filmCell
            }
            
            if indexPath.section == self.TopicSection, case let .topics(topics) = item {
                self.topicCell.topics = topics
                return self.topicCell
            }
            
            if indexPath.section == self.SongSection, case let .songs(songs) = item {
                self.songCell.songs = songs
                return self.songCell
            }
            
            return UITableViewCell()
        }
        
        dataSource.titleForHeaderInSection = { dataSource, section in dataSource[section].model }
        
        return dataSource
    }()
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = HomeHeaderSectionView(size: CGSize(
            width: tableView.bounds.width, height: HomeHeaderSectionView.defaultHeight
        ))
        
        switch section {
        case PlaylistSection:
            header.text = "Playlist | Album"
            header.action = CocoaAction {
                self.delegate?.homeViewControllerSwitchToPlaylistViewController(self)
                return .empty()
            }
        case VideoSection:
            header.text = "Video | MV"
            header.action = CocoaAction {
                self.delegate?.homeViewControllerSwitchToVideoViewController(self)
                return .empty()
            }
        case FilmSection:
            header = HomeHeaderSectionView(size: CGSize(
                width: tableView.bounds.width, height: HomeHeaderSectionView.defaultHeight
            ), moreButtonEnabled: false)
            header.text = "Phim | Hài Kịch"
        case TopicSection:
            header.text = "Chủ Đề"
            header.action = CocoaAction {
                self.delegate?.homeViewControllerSwitchToTopicViewController(self)
                return .empty()
            }
        case SongSection:
            header.text = "Bài Hát"
            header.action = CocoaAction {
                self.delegate?.homeViewControllerSwitchToSongViewController(self)
                return .empty()
            }
        default:
            break
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == AdvertisementSection || section == PageSection { return 0 }
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == AdvertisementSection {
            return 50
        }
        
        if indexPath.section == PageSection {
            return 150
        }
        
        if indexPath.section == PlaylistSection {
            let itemSize = PlaylistOptions.shared.width(of: tableView)
            let itemPadding = PlaylistOptions.shared.itemPadding
            return 3 * itemSize + 4 * itemPadding
        }
        
        if indexPath.section == VideoSection || indexPath.section == FilmSection {
            let itemSize = VideoOptions.shared.height(of: tableView)
            let itemPadding = VideoOptions.shared.itemPadding
            return 2 * itemSize + 3 * itemPadding
        }
        
        if indexPath.section == TopicSection {
            let itemSize = TopicOptions.shared.height(of: tableView)
            let itemPadding = TopicOptions.shared.itemPadding
            return 2 * itemSize + 3 * itemPadding
        }
        
        if indexPath.section == SongSection {
            return 44 * CGFloat(store.info.value?.songs.count ?? 0)
        }
        
        return 0
    }
    
    private struct PlaylistOptions: HomePlaylistCellOptions {
        static let shared = PlaylistOptions()
    }
    
    private struct VideoOptions: HomeVideoCellOptions {
        static let shared = VideoOptions()
    }
    
    private struct TopicOptions: HomeTopicCellOptions {
        static let shared = TopicOptions()
    }
    
}

extension HomeViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Home", image: #imageLiteral(resourceName: "home"))
    }
    
}

extension HomeViewController {
    
    func bindStore() {
        store.info.asObservable()
            .filter { $0 != nil }
            .map { $0! }
            .do(onNext: { [weak self] _ in
                self?.initialIndicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            })
            .map { info in [
                SectionModel(model: "Advertisement", items: [.advertisement]),
                SectionModel(model: "Pages", items: [.pages(info.pages)]),
                SectionModel(model: "Playlists", items: [.playlists(info.playlists)]),
                SectionModel(model: "Videos", items: [.videos(info.videos)]),
                SectionModel(model: "Films", items: [.films(info.films)]),
                SectionModel(model: "Topics", items: [.topics(info.topics)]),
                SectionModel(model: "Songs", items: [.songs(info.songs)])
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
    
        store.info.asObservable()
            .filter { $0 == nil }
            .subscribe(onNext: { [weak self] _ in
                self?.initialIndicatorView.startAnimating(in: self?.view)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension HomeViewController {
    
    func bindAction() {
        action.onLoad.execute(())
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                self?.action.onLoad.execute(())
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}

protocol HomeViewControllerDelegate: class {
    
    func homeViewControllerSwitchToPlaylistViewController(_ controller: HomeViewController)
    func homeViewControllerSwitchToVideoViewController(_ controller: HomeViewController)
    func homeViewControllerSwitchToTopicViewController(_ controller: HomeViewController)
    func homeViewControllerSwitchToSongViewController(_ controller: HomeViewController)
    
}
