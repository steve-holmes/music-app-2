//
//  SearchGeneralViewController.swift
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

class SearchGeneralViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var store: SearchStore!
    var action: SearchAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        bindStore()
        bindAction()
    }
    
    fileprivate let SongSection = 0
    fileprivate let PlaylistSection = 1
    fileprivate let VideoSection = 2
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, SearchItem>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, SearchItem>>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, item in
            if indexPath.section == self.SongSection, case let .song(song) = item {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SongCell.self), for: indexPath)
                if let cell = cell as? SongCell {
                    let contextAction = CocoaAction { _ in
                        return self.action.onContextButtonTap.execute(song).map { _ in }
                    }
                    cell.configure(name: song.name, singer: song.singer, contextAction: contextAction)
                }
                return cell
            }
            
            if indexPath.section == self.PlaylistSection, case let .playlist(playlist) = item {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaylistDetailCell.self), for: indexPath)
                if let cell = cell as? PlaylistDetailCell {
                    cell.configure(name: playlist.name, singer: playlist.singer, image: playlist.avatar)
                }
                return cell
            }
            
            if indexPath.section == self.VideoSection , case let .video(video) = item {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideoItemCell.self), for: indexPath)
                if let cell = cell as? VideoItemCell {
                    cell.configure(name: video.name, singer: video.singer, image: video.avatar)
                }
                return cell
            }
            
            dataSource.titleForHeaderInSection = { dataSource, section in dataSource[section].model }
            
            return UITableViewCell()
        }
        
        return dataSource
    }()

}

extension SearchGeneralViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SongSection { return 44 }
        if indexPath.section == PlaylistSection { return 60 }
        if indexPath.section == VideoSection { return 80 }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == SongSection {
            let songHeader = SearchGeneralSectionHeaderView(frame: CGRect(
                origin: .zero,
                size: CGSize(width: tableView.bounds.width, height: 35)
            ))
            songHeader.title = "Bài hát"
            songHeader.action = CocoaAction { [weak self] _ in self?.action.searchStateChange.execute(.song) ?? .empty() }
            return songHeader
        }
        
        if section == PlaylistSection {
            let playlistHeader = SearchGeneralSectionHeaderView(frame: CGRect(
                origin: .zero,
                size: CGSize(width: tableView.bounds.width, height: 35)
            ))
            playlistHeader.title = "Playlist"
            playlistHeader.action = CocoaAction { [weak self] _ in self?.action.searchStateChange.execute(.playlist) ?? .empty() }
            return playlistHeader
        }
        
        if section == VideoSection {
            let videoHeader = SearchGeneralSectionHeaderView(frame: CGRect(
                origin: .zero,
                size: CGSize(width: tableView.bounds.width, height: 35)
            ))
            videoHeader.title = "Video"
            videoHeader.action = CocoaAction { [weak self] _ in self?.action.searchStateChange.execute(.video) ?? .empty() }
            return videoHeader
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
}

extension SearchGeneralViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Tất cả"
    }
    
}

extension SearchGeneralViewController {
    
    func bindStore() {
        bindSearchResult()
    }
    
    private func bindSearchResult() {
        let songs = store.songs.asObservable().filter { $0.count > 0 }
        let playlists = store.playlists.asObservable().filter { $0.count > 0 }
        let videos = store.videos.asObservable().filter { $0.count > 0 }
        
        Observable
            .combineLatest(songs, playlists, videos) { songs, playlists, videos in
                (songs: songs, playlists: playlists, videos: videos)
            }
            .filter { [weak self] _ in (self?.store.state.value ?? .all) == .all }
            .map { songs, playlists, videos in [
                SectionModel(model: "Songs", items: songs.map { SearchItem.song($0) }),
                SectionModel(model: "Playlists", items: playlists.map { SearchItem.playlist($0) }),
                SectionModel(model: "Videos", items: videos.map { SearchItem.video($0) })
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension SearchGeneralViewController {
    
    func bindAction() {
        tableView.rx.modelSelected(SearchItem.self)
            .filter { item in
                if case .song(_) = item { return true } else { return false }
            }
            .map { item -> Song? in
                if case let .song(song) = item { return song } else { return nil }
            }
            .subscribe(onNext: { [weak self] song in
                guard let song = song else { return }
                self?.action.songDidSelect.execute(song)
            })
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx.modelSelected(SearchItem.self)
            .filter { item in
                if case .playlist(_) = item { return true } else { return false }
            }
            .map { item -> Playlist? in
                if case let .playlist(playlist) = item { return playlist } else { return nil }
            }
            .subscribe(onNext: { [weak self] playlist in
                guard let playlist = playlist else { return }
                self?.action.playlistDidSelect.execute(playlist)
            })
            .addDisposableTo(rx_disposeBag)
        
        tableView.rx.modelSelected(SearchItem.self)
            .filter { item in
                if case .video(_) = item { return true } else { return false }
            }
            .map { item -> Video? in
                if case let .video(video) = item { return video } else { return nil }
            }
            .subscribe(onNext: { [weak self] video in
                guard let video = video else { return }
                self?.action.videoDidSelect.execute(video)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}
